import 'package:redux_thunk/redux_thunk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foster_friends/containers/authentication/authentication.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

final ref = Firestore.instance;
Geoflutterfire geo = Geoflutterfire();

// AppState
class AppState {
  FirebaseUser _user;
  Map<String, dynamic> _userData;
  List<Map<String, dynamic>> _query;

  FirebaseUser get user => _user;
  Map<String, dynamic> get userData => _userData;
  List<Map<String, dynamic>> get query => _query;

  AppState(this._user, this._userData, this._query);

  get index => null;
}

/* --------------------- USER AUTHENTICATION --------------------- */
// User information class
class UpdateUserAction {
  FirebaseUser _user;
  Map<String, dynamic> _userData;

  FirebaseUser get user => this._user;
  Map<String, dynamic> get userData => this._userData;

  UpdateUserAction(this._user, this._userData);
}

// Async function that pulls user profile from database
ThunkAction<AppState> getFirebaseUser = (Store<AppState> store) async {
//  await signOut();
  FirebaseAuth.instance.currentUser().then((u) async {
    if (u == null) {
      store.dispatch(new UpdateUserAction(null, null));
    } else {
      final data = await getUserData(u.uid);

      store.dispatch(new UpdateUserAction(u, data));
    }
  });
};

/* --------------------- QUERIES  --------------------- */
// Query class --> holds results of a query and updates UI
class UpdateQueryAction {
  List<Map<String, dynamic>> _results;
  List<Map<String, dynamic>> get results => this._results;

  UpdateQueryAction(this._results);
}

// async function that pulls data based on query from database
ThunkActionWithExtraArgument<AppState, Map<String, dynamic>> makeQuery =
    (Store<AppState> store, Map<String, dynamic> params) async {
  List<Map<String, dynamic>> petInfo = [];

  /* 
    'Type', 'Breed', 'Sex', 'Age', 'Shelter', 'Address'
  */
  print("Search params are $params");
  Query query = ref.collection('pets');

  GeoFirePoint g = geo.point(latitude: 37.785834, longitude: -122.406417);

  print("Firepoint is " + g.hash);
  double radius = 50;
  String field = 'test';

  CollectionReference petCollection = ref.collection('pets');
  geo
      .collection(collectionRef: petCollection)
      .setPoint('7ODiubljoL0SHEETdH1V', 'test', g.latitude , g.longitude);

  Stream<List<DocumentSnapshot>> results = geo
      .collection(collectionRef: petCollection)
      .within(center: g, radius: radius, field: field, strictMode: true);

  await for (List<DocumentSnapshot> res in results) {
    for (DocumentSnapshot pet in res) {
      petInfo.add(Map.from(pet.data));
    }
    print(petInfo);
  }

  // for (String elem in params.keys) {
  //   if (params[elem] != null) {
  //     print("Searching for $elem " +
  //         params[elem].runtimeType.toString() +
  //         " " +
  //         params[elem].toString());
  //     if (elem == 'minAge') {
  //       query = query.where('age', isGreaterThanOrEqualTo: params[elem]);
  //     } else if (elem != 'maxAge') {
  //       query = query.where(elem, isEqualTo: params[elem]);
  //     }
  //   }
  // }

  // if (params['maxAge'] != null) {
  //   print(params['minAge']);
  //   if(params['minAge'] == null){
  //     query = query.where('age', isLessThanOrEqualTo: params['maxAge'] );
  //   } else{
  //     query = query.orderBy('age');
  //   }
  // }

  QuerySnapshot result = await query.getDocuments();

  for (var snapshot in result.documents) {
    Map<String, dynamic> pet = Map.from(snapshot.data);
    // print("Query yields $pet");
    petInfo.add(pet);
  }

  print("Results are $petInfo");

  store.dispatch(new UpdateQueryAction(petInfo));
};

Future<List<Map<String, dynamic>>> getAllPets() async {
  List<Map<String, dynamic>> petInfo = [];

  // The syntax for the query should be something like this:
  CollectionReference pets = ref.collection('pets');
  QuerySnapshot result = await pets.getDocuments();

  for (var snapshot in result.documents) {
    Map<String, dynamic> pet = Map.from(snapshot.data);
    petInfo.add(pet);
  }

  return petInfo;
}

/* --------------------- REDUCER: HANDLES ACTION TYPES  --------------------- */
AppState reducer(AppState prev, dynamic action) {
  if (action is UpdateUserAction) {
    AppState newAppState =
        new AppState(action.user, action.userData, prev._query);
    return newAppState;
  } else if (action is UpdateQueryAction) {
    AppState newAppState =
        new AppState(prev.user, prev.userData, action.results);
    return newAppState;
  } else {
    return prev;
  }
}

/* --------------------- INITIALIZATION OF STORE  --------------------- */
final store = new Store<AppState>(reducer,
    initialState: new AppState(null, null, []), middleware: [thunkMiddleware]);
