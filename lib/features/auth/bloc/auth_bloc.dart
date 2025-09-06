// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../../../core/models/user_model.dart';
// import 'auth_event.dart';
// import 'auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final FirebaseAuth _firebaseAuth;
//   final GoogleSignIn _googleSignIn;
//   final FirebaseFirestore _firestore;
//   StreamSubscription<User?>? _userSubscription;

//   AuthBloc({
//     FirebaseAuth? firebaseAuth,
//     GoogleSignIn? googleSignIn,
//     FirebaseFirestore? firestore,
//   })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
//         _googleSignIn = googleSignIn ?? GoogleSignIn.withScopes(['email']),
//         _firestore = firestore ?? FirebaseFirestore.instance,
//         super(const AuthState()) {
//     on<AuthStarted>(_onAuthStarted);
//     on<AuthSignInRequested>(_onSignInRequested);
//     on<AuthSignUpRequested>(_onSignUpRequested);
//     on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
//     on<AuthSignOutRequested>(_onSignOutRequested);
//     on<AuthUserChanged>(_onUserChanged);
//   }

//   @override
//   Future<void> close() {
//     _userSubscription?.cancel();
//     return super.close();
//   }

//   Future<void> _onAuthStarted(
//     AuthStarted event,
//     Emitter<AuthState> emit,
//   ) async {
//     _userSubscription = _firebaseAuth.authStateChanges().listen(
//       (firebaseUser) async {
//         if (firebaseUser != null) {
//           try {
//             final userDoc = await _firestore
//                 .collection('users')
//                 .doc(firebaseUser.uid)
//                 .get();

//             if (userDoc.exists) {
//               final userData = userDoc.data()!;
//               final user = UserModel.fromJson({
//                 'id': firebaseUser.uid,
//                 ...userData,
//               });
//               add(AuthUserChanged(user));
//             } else {
//               add(const AuthUserChanged(null));
//             }
//           } catch (e) {
//             add(const AuthUserChanged(null));
//           }
//         } else {
//           add(const AuthUserChanged(null));
//         }
//       },
//     );
//   }

//   Future<void> _onSignInRequested(
//     AuthSignInRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));

//     try {
//       await _firebaseAuth.signInWithEmailAndPassword(
//         email: event.email,
//         password: event.password,
//       );
//     } on FirebaseAuthException catch (e) {
//       emit(state.copyWith(
//         isLoading: false,
//         errorMessage: _getAuthErrorMessage(e.code),
//       ));
//     } catch (e) {
//       emit(state.copyWith(
//         isLoading: false,
//         errorMessage: 'An unexpected error occurred',
//       ));
//     }
//   }

//   Future<void> _onSignUpRequested(
//     AuthSignUpRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));

//     try {
//       final credential = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: event.email,
//         password: event.password,
//       );

//       if (credential.user != null) {
//         await credential.user!.updateDisplayName(event.displayName);

//         final user = UserModel(
//           id: credential.user!.uid,
//           email: event.email,
//           displayName: event.displayName,
//           photoUrl: credential.user!.photoURL,
//           role: event.role,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//         );

//         await _firestore
//             .collection('users')
//             .doc(credential.user!.uid)
//             .set(user.toJson());
//       }
//     } on FirebaseAuthException catch (e) {
//       emit(state.copyWith(
//         isLoading: false,
//         errorMessage: _getAuthErrorMessage(e.code),
//       ));
//     } catch (e) {
//       emit(state.copyWith(
//         isLoading: false,
//         errorMessage: 'An unexpected error occurred',
//       ));
//     }
//   }

//   Future<void> _onGoogleSignInRequested(
//     AuthGoogleSignInRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));

//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser != null) {
//         final GoogleSignInAuthentication googleAuth =
//             googleUser.authentication;

//         final credential = GoogleAuthProvider.credential(
//           accessToken: (await googleAuth).accessToken,
//           idToken: (await googleAuth).idToken,
//         );

//         final userCredential =
//             await _firebaseAuth.signInWithCredential(credential);

//         if (userCredential.user != null) {
//           final userDoc = await _firestore
//               .collection('users')
//               .doc(userCredential.user!.uid)
//               .get();

//           if (!userDoc.exists) {
//             final user = UserModel(
//               id: userCredential.user!.uid,
//               email: userCredential.user!.email!,
//               displayName: userCredential.user!.displayName ?? 'User',
//               photoUrl: userCredential.user!.photoURL,
//               role: UserRole.reader, // Default role for Google sign-in
//               createdAt: DateTime.now(),
//               updatedAt: DateTime.now(),
//             );

//             await _firestore
//                 .collection('users')
//                 .doc(userCredential.user!.uid)
//                 .set(user.toJson());
//           }
//         }
//       }
//     } catch (e) {
//       emit(state.copyWith(
//         isLoading: false,
//         errorMessage: 'Google sign-in failed',
//       ));
//     }
//   }

//   Future<void> _onSignOutRequested(
//     AuthSignOutRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     await _firebaseAuth.signOut();
//     await _googleSignIn.signOut();
//   }

//   void _onUserChanged(
//     AuthUserChanged event,
//     Emitter<AuthState> emit,
//   ) {
//     if (event.user != null) {
//       emit(state.copyWith(
//         status: AuthStatus.authenticated,
//         user: event.user,
//         isLoading: false,
//         errorMessage: null,
//       ));
//     } else {
//       emit(state.copyWith(
//         status: AuthStatus.unauthenticated,
//         user: null,
//         isLoading: false,
//         errorMessage: null,
//       ));
//     }
//   }

//   String _getAuthErrorMessage(String code) {
//     switch (code) {
//       case 'user-not-found':
//         return 'No user found with this email';
//       case 'wrong-password':
//         return 'Wrong password provided';
//       case 'email-already-in-use':
//         return 'An account already exists with this email';
//       case 'weak-password':
//         return 'Password is too weak';
//       case 'invalid-email':
//         return 'Invalid email address';
//       default:
//         return 'Authentication failed';
//     }
//   }
// }