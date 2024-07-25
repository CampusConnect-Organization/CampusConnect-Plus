import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_connect_plus/models/profile.model.dart';
import 'package:campus_connect_plus/services/profile.service.dart';
import 'package:campus_connect_plus/utils/constants.dart';
import 'package:campus_connect_plus/utils/global.colors.dart';
import 'package:campus_connect_plus/view/home.view.dart';
import 'package:campus_connect_plus/view/login.view.dart';
import 'package:campus_connect_plus/widgets/spinner.widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  InstructorProfile? profile;
  bool isRefreshing = false;

  final ImagePicker _imagePicker = ImagePicker();


   

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    dynamic data = await ProfileAPIService().getProfile();
    if (data is InstructorProfile) {
      setState(() {
        profile = data;
      });
    } else {
      Get.off(() => const LoginView());
    }
  }

  Future<void> refreshProfile() async {
    setState(() {
      isRefreshing = true;
    });
    await fetchProfile();

    setState(() {
      isRefreshing = false;
    });
  }

  Future<void> _pickProfilePicture() async{
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      File imageFile = File(pickedFile.path);
      await ProfileAPIService().updateProfilePicture(imageFile);
      await refreshProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Profile"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.off(() => const HomeView()),
        ),
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.notifications, color: Colors.white),
          )
        ],
        backgroundColor: GlobalColors.mainColor,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: refreshProfile,
        child: profile != null
            ? SingleChildScrollView(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: _pickProfilePicture,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: CachedNetworkImageProvider(ApiConstants.baseUrl +
                                    profile!.data.profilePicture),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          profile!.data.fullName,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.phone,
                              color: Colors.grey,
                              size: 15.0,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              profile!.data.phoneNumber,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildProfileCard(),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: ModernSpinner(
                  color: GlobalColors.mainColor,
                ),
              ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.genderless,
                color: Colors.grey,
              ),
              title: Text(
                titleCase(profile!.data.gender),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.locationPin,
                color: Colors.grey,
              ),
              title: Text(
                profile!.data.address,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.graduationCap,
                color: Colors.grey,
                size: 20,
              ),
              title: Text(
                "${titleCase(profile!.data.faculty)} Department",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.book,
                color: Colors.grey,
              ),
              title: Text(
                profile!.data.education,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
