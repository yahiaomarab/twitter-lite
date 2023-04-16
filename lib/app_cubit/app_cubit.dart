import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_lite/app_cubit/app_states.dart';
import 'package:twitter_lite/shared/components/components.dart';
import 'package:twitter_lite/shared/network/local/cache_helper.dart';
import 'package:twitter_lite/view/login/login_screen.dart';
import '../data/models/comment_model.dart';
import '../data/models/message_model.dart';
import '../data/models/post_model.dart';
import '../data/models/social_user_model.dart';
import 'package:twitter_lite/shared/components/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../view/feeds/feeds_screen.dart';
import '../view/settings/app_settings.dart';
import '../view/settings/profileSettings_screen.dart';
import '../view/users/users_screen.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialStates());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  List<UserModel> users = [];
  void getUsers() {
    users = [];
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uId'] != userModel!.uId) {
          users.add(UserModel.fromJson(element.data()));
        }
      }
      emit(SocialGetAllUserSuccessState());
    }).catchError((error) {
      emit(SocialGetAllUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    const FeedsScreen(),
    UsersScreen(),
    ProfileSettingsScreen(),
    AppSettings(),
  ];

  List<String> titles = ['Home',  'Friends', 'Profile', 'Settings'];

  void changeBottomNav(int index) {
    currentIndex = index;
    if (currentIndex == 0) {
      getPosts();
    }
    if (currentIndex == 2) {
      getUsers();
    }
    if (currentIndex == 3) {
      getSomeonePosts(userModel!.uId!);
    }
    if (currentIndex == 1) {
      getUsers();
    }
    emit(SocialChangeBottomNavBarState());
  }

  dynamic profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      uploadProfileImage();
      //emit(SocialProfileImagePickedSuccessState());
    } else {
      emit(SocialProfileImagePickedErrorState());
    }
  }

  dynamic coverImage;
  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      uploadCoverImage();
      //emit(SocialCoverImagePickedSuccessState());
    } else {
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void uploadProfileImage() {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(
            name: userModel!.name!,
            phone: userModel!.phone!,
            bio: userModel!.bio!,
            image: value);
        emit(SocialUploadProfileImageSuccessState());
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage() {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(
            name: userModel!.name!,
            phone: userModel!.phone!,
            bio: userModel!.bio!,
            cover: value);
        emit(SocialUploadCoverImageSuccessState());
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUser(
      {required String name,
      required String phone,
      required String bio,
      String? image,
      String? cover}) {
    emit(SocialUserUpdateLoadingState());
    UserModel model = UserModel(
        name: name,
        phone: phone,
        image: image ?? userModel!.image,
        email: userModel!.email,
        cover: cover ?? userModel!.cover,
        uId: userModel!.uId,
        bio: bio,
        isEmailVerified: false);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      emit(SocialUserUpdateSuccessState());
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  dynamic postImage;

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      emit(SocialPostImagePickedErrorState());
    }
  }

  void uploadPostImage(
      {required String date,
      required String postText,
      bool isAccountVerified = false}) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(date: date, postText: postText, postImage: value);
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String date,
    dynamic postImage,
     String? postText,
  }) {
    emit(SocialUserUpdateLoadingState());
    PostModel model = PostModel(
        image: userModel!.image,
        name: userModel!.name,
        uId: userModel!.uId,
        date: date,
        postImage: postImage ?? '',
        postText: postText?? '',
        isAccountVerified: false);
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
      getPosts();
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int> commentsSum = [];

  void getPosts() {
    posts = [];
    likes = [];
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
          emit(SocialGetPostsSuccessState());
        }).catchError((error) {
          emit(SocialLikePostErrorState(error.toString()));
        });
      }
      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      // getPosts();
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
        text: text,
        senderId: userModel!.uId,
        receiverId: receiverId,
        dateTime: dateTime);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection("chats")
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(SocialGetMessagesSuccessState());
    });
  }

  void commentOnPost({
    required String postId,
    required String dateTime,
    required String text,
  }) {
    CommentModel model = CommentModel(
        text: text,
        senderId: userModel!.uId,
        postId: postId,
        dateTime: dateTime,
        senderName: userModel!.name,
        senderImage: userModel!.image);
    emit(SocialCommentLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(model.toMap())
        .then((value) {
      emit(SocialCommentSuccessState());
    }).catchError((error) {
      emit(SocialCommentErrorState());
    });
  }

  List<CommentModel> comments = [];

  void getComments(postId) {
    emit(SocialGetCommentsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection("comments")
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      comments = [];
      for (var element in event.docs) {
        comments.add(CommentModel.fromJson(element.data()));
      }
      emit(SocialGetCommentsSuccessState());
    });
  }

  UserModel? anotherUserModel;
  void getAnotherUser(String userId) {
    emit(SocialGetAnotherUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      anotherUserModel = UserModel.fromJson(value.data());
      emit(SocialGetAnotherUserSuccessState());
    }).catchError((error) {
      emit(SocialGetAnotherUserErrorState());
    });
  }

  List<PostModel> someonePosts = [];
  List<String> someonePostsId = [];
  List<int> someoneLikes = [];
  List<int> someoneCommentsSum = [];

  void getSomeonePosts(String userId) {
    emit(SocialGetSomeonePostsLoadingState());
    someonePosts = [];
    someoneLikes = [];
    someonePostsId = [];
    someoneCommentsSum = [];
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        if (element.get('uId') == userId) {
          element.reference.collection('likes').get().then((value) {
            someoneLikes.add(value.docs.length);
            someonePostsId.add(element.id);
            someonePosts.add(PostModel.fromJson(element.data()));
            emit(SocialGetSomeonePostsSuccessState());
          }).catchError((error) {
            emit(SocialLikePostErrorState(error.toString()));
          });
        }
      }
      emit(SocialGetSomeonePostsSuccessState());
    }).catchError((error) {
      emit(SocialGetSomeonePostsErrorState(error.toString()));
    });
  }

  void followSomeone(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('homies')
        .doc(userModel!.uId)
        .set({
      'homie': true,
    }).then((value) {
      emit(SocialFollowSomeoneSuccessState());
    }).catchError((error) {
      emit(SocialFollowSomeoneErrorState(error.toString()));
    });
  }

  void unFollowSomeone(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('homies')
        .doc(userModel!.uId)
        .delete()
        .then((value) {
      emit(SocialUnFollowSomeoneSuccessState());
      isMyProfile(userId);
    }).catchError((error) {
      emit(SocialUnFollowSomeoneErrorState(error.toString()));
    });
  }

  var followers;
  int? getNumOfFollowers(String userId) {
    followers = 0;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('homies')
        .get()
        .then((value) {
      followers = value.docs.length;
    });
    return followers;
  }

  var myId;
  bool? isMyProfile(String userId) {
    myId = false;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('homies')
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (element.id == userModel!.uId) {
          myId = true;
        }
      }
    });
    return myId;
  }

  var myLike;
  dynamic isLiked(String postId) {
    myLike = false;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (element.id == userModel!.uId) {
          myLike = true;
          emit(SocialisLikedPostSuccessState());
        }
      }

      return myLike;
    });
  }

  List<UserModel> search = [];
  void getSearch(String name) async {
    search = [];
    for (var element in users) {
      if (element.name!.toLowerCase().startsWith(name.toLowerCase())) {
        search.add(element);
      }
    }
    emit(SocialGetSearchUserSuccessState());
  }

  bool isDark = false;
  changeMode({bool? fromShare}) {
    if (fromShare != null) {
      isDark = fromShare;
      emit(ChangeModeSuccessState());
    } else {
      isDark = !isDark;
    }
    CacheHelper.setBool("isDark", isDark).then((value) {
      emit(ChangeModeSuccessState());
    });
  }

  signOut(context) {
    CacheHelper.remove(uId);
    navigateAndFinish(context, LoginScreen());
    emit(SocialLoginOutSuccessState());
  }
}
