import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/theme/colors.dart';

class BuildFullCardProfile extends StatefulWidget {
  const BuildFullCardProfile({super.key});

  @override
  State<BuildFullCardProfile> createState() => _BuildFullCardProfileState();
}

class _BuildFullCardProfileState extends State<BuildFullCardProfile> {
  String imageUrl = '';
  String localImage = "assets/images/profile/Profile Avatar.png";
  File? pickedImage; // الصورة اللي هيختارها المستخدم
//i
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
        imageUrl = ''; // عشان يلغي الصورة اللي من النت
      });
    }
  }

  void _showPickOptionsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.photo,color: AppColors.primary,size: 19,),
              title: const Text("Pick From Gallery", style: TextStyle(
                fontWeight: FontWeight.w500,color: AppColors.primary,
                fontSize: 14.5,fontFamily: 'Poppins'
              ),),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const   Icon(CupertinoIcons.photo_camera,
                color: AppColors.primary,size: 19,
              ),
              title: const Text("Pick From Camera", style: TextStyle(
                fontWeight: FontWeight.w500,color: AppColors.primary,fontFamily: 'Poppins',
                fontSize: 14.5,
              )),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    double size = screenWidth * 0.25; // 👈 ثابت لدائرة مظبوطة

    return Container(
      height: screenHeight * .22,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * .01,
        horizontal: screenWidth * .02,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.whiteColor,
      ),
      child: Center(
        child: Stack(
          children: [
            Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: AppColors.backgrounHome,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: pickedImage != null
                    ? Image.file(
                  pickedImage!,
                  fit: BoxFit.cover,
                )
                    : imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(localImage, fit: BoxFit.cover);
                  },
                )
                    : Image.asset(localImage, fit: BoxFit.cover),
              ),
            ),

            /// زرار تعديل الصورة
            Positioned(
              bottom: size * 0.08,
              right: size * 0.08,
              child: GestureDetector(
                onTap: _showPickOptionsDialog,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    'assets/images/profile/edit.svg',
                    color: AppColors.whiteColor,
                    height: screenHeight * .02,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
