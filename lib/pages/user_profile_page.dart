import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomuser/models/address_model.dart';
import 'package:ecomuser/models/user_model.dart';
import 'package:ecomuser/pages/otp_verification_page.dart';
import 'package:ecomuser/providers/user_provider.dart';
import 'package:ecomuser/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  static const String routeName = '/add_user_profile';
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'My Profile',
        ),
      ),
      body: userProvider.userModel == null
          ? const Center(
              child: Text(
                'Failed to load data',
              ),
            )
          : ListView(
              children: [
                headerSection(context, userProvider),
                ListTile(
                  leading: const Icon(Icons.call),
                  title: Text(
                    userProvider.userModel!.phone == null
                        ? 'Not set yet'
                        : userProvider.userModel!.phone!,
                  ),
                  subtitle: const Text('Mobile'),
                  trailing: IconButton(
                      onPressed: () {
                        showSingleTextInputDialog(
                            context: context,
                            title: 'Mobile Number',
                            onSubmit: (value) {
                              Navigator.pushNamed(
                                  context, OtpVerificationPage.routeName,
                                  arguments: value);
                            });
                      },
                      icon: const Icon(Icons.edit)),
                ),
                ListTile(
                  leading: const Icon(Icons.date_range),
                  title: Text(
                    userProvider.userModel!.age == null
                        ? 'Not set yet'
                        : userProvider.userModel!.age!,
                  ),
                  subtitle: const Text('Date of Birth'),
                  trailing: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.edit)),
                ),
                ListTile(
                  leading: const Icon(Icons.transgender),
                  title: Text(
                    userProvider.userModel!.gender == null
                        ? 'Not set yet'
                        : userProvider.userModel!.gender!,
                  ),
                  subtitle: const Text('Gender'),
                  trailing: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.edit)),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(
                    userProvider.userModel!.addressModel?.addressLine1 == null
                        ? 'Not set yet'
                        : userProvider.userModel!.addressModel!.addressLine1!,
                  ),
                  subtitle: const Text('Address 1'),
                  trailing: IconButton(
                    onPressed: () {
                      showSingleTextInputDialog(
                        context: context,
                        title: 'Enter Address 1',
                        onSubmit: (value) {
                          userProvider.updateUserProfileField(
                              '$userFieldAddressModel.$addressFieldAddressLine1',
                              value);
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(
                    userProvider.userModel!.addressModel?.addressLine2 == null
                        ? 'Not set yet'
                        : userProvider.userModel!.addressModel!.addressLine2!,
                  ),
                  subtitle: const Text('Address 2'),
                  trailing: IconButton(
                      onPressed: () {
                        showSingleTextInputDialog(
                          context: context,
                          title: 'Enter Address 2',
                          onSubmit: (value) {
                            userProvider.updateUserProfileField(
                                '$userFieldAddressModel.$addressFieldAddressLine2',
                                value);
                          },
                        );
                      },
                      icon: const Icon(Icons.edit)),
                ),
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(
                    userProvider.userModel!.addressModel?.city == null
                        ? 'Not set yet'
                        : userProvider.userModel!.addressModel!.city!,
                  ),
                  subtitle: const Text('City'),
                  trailing: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.edit)),
                ),
                ListTile(
                  leading: const Icon(Icons.folder_zip),
                  title: Text(
                    userProvider.userModel!.addressModel?.zipcode == null
                        ? 'Not set yet'
                        : userProvider.userModel!.addressModel!.zipcode!,
                  ),
                  subtitle: const Text('Zip Code'),
                  trailing: IconButton(
                      onPressed: () {
                        showSingleTextInputDialog(
                          context: context,
                          title: 'Enter ZipCode',
                          onSubmit: (value) {
                            userProvider.updateUserProfileField(
                                '$userFieldAddressModel.$addressFieldZipcode',
                                value);
                          },
                        );
                      },
                      icon: const Icon(Icons.edit)),
                ),
              ],
            ),
    );
  }

  Container headerSection(BuildContext context, UserProvider userProvider) {
    return Container(
      height: 150,
      color: Theme.of(context).primaryColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              elevation: 5,
              child: SizedBox(
                height: 100,
                width: 100,
                child: userProvider.userModel!.imageUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 90,
                        color: Colors.brown,
                      )
                    : ClipOval(
                        child: CachedNetworkImage(
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          imageUrl: userProvider.userModel!.imageUrl!,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      ),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userProvider.userModel!.displayName == null
                    ? 'User Name'
                    : userProvider.userModel!.displayName!,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
              Text(
                userProvider.userModel!.email,
                style: const TextStyle(color: Colors.white60),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // void _selectDate() async {
  //   final date = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(DateTime.now().year - 1),
  //     lastDate: DateTime.now(),
  //   );
  //   if (date != null) {
  //     setState(() {
  //       dateOfBirth = date;
  //     });
  //   }
  // }
  //
  // void _getImage(ImageSource imageSource) async {
  //   final pickedImage = await ImagePicker().pickImage(
  //     source: imageSource,
  //     imageQuality: 70,
  //   );
  //   if (pickedImage != null) {
  //     setState(() {
  //       profileImageUrl = pickedImage.path;
  //     });
  //   }
  // }
}
// Form(
// key: _formKey,
// child: ListView(
// padding: EdgeInsets.all(16),
// children: [
// if (!_isConnected)
// const ListTile(
// tileColor: Colors.red,
// title: Text(
// 'No internet connectivity',
// style: TextStyle(color: Colors.white),
// ),
// ),
//
// //image picker
// Card(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// mainAxisSize: MainAxisSize.min,
// children: [
// Card(
// child: profileImageUrl == null
// ? const Icon(
// Icons.photo,
// size: 100,
// )
// : Image.file(
// File(profileImageUrl!),
// width: 100,
// height: 100,
// fit: BoxFit.cover,
// ),
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// TextButton.icon(
// onPressed: () {
// _getImage(ImageSource.camera);
// },
// icon: const Icon(Icons.camera),
// label: const Text('Open Camera'),
// ),
// TextButton.icon(
// onPressed: () {
// _getImage(ImageSource.gallery);
// },
// icon: const Icon(Icons.photo_album),
// label: const Text('Open Gallery'),
// ),
// ],
// )
// ],
// ),
// ),
// ),
// //user name
// Padding(
// padding: const EdgeInsets.symmetric(vertical: 4.0),
// child: TextFormField(
// controller: _nameController,
// decoration: const InputDecoration(
// filled: true,
// labelText: 'Enter User Name',
// ),
// validator: (value) {
// if (value == null || value.isEmpty) {
// return 'This field must not be empty';
// }
// return null;
// },
// ),
// ),
//
// //email
// Padding(
// padding: const EdgeInsets.symmetric(vertical: 4.0),
// child: TextFormField(
// controller: _emailController,
// keyboardType: TextInputType.emailAddress,
// decoration: const InputDecoration(
// filled: true,
// labelText: 'Enter User Email',
// ),
// validator: (value) {
// if (value == null || value.isEmpty) {
// return 'This field must not be empty';
// }
// return null;
// },
// ),
// ),
//
// //phone
// Padding(
// padding: const EdgeInsets.symmetric(vertical: 4.0),
// child: TextFormField(
// controller: _emailController,
// keyboardType: TextInputType.phone,
// decoration: const InputDecoration(
// filled: true,
// labelText: 'Enter User Phone',
// ),
// validator: (value) {
// if (value == null || value.isEmpty) {
// return 'This field must not be empty';
// }
// return null;
// },
// ),
// ),
//
// //address
// Padding(
// padding: const EdgeInsets.symmetric(vertical: 4.0),
// child: TextFormField(
// maxLines: 2,
// controller: _addressController,
// decoration: const InputDecoration(
// filled: true,
// labelText: 'Enter Address',
// ),
// validator: (value) {
// if (value == null || value.isEmpty) {
// return 'This field must not be empty';
// }
// return null;
// },
// ),
// ),
//
// //gender
// Row(
// children: [
// RadioListTile(
// title: const Text('Male'),
// value: 'male',
// groupValue: gender,
// onChanged: (value) {
// setState(() {
// gender = value;
// });
// }),
// RadioListTile(
// title: const Text('Female'),
// value: 'female',
// groupValue: gender,
// onChanged: (value) {
// setState(() {
// gender = value;
// });
// }),
// ],
// ),
// //date of birth
// Card(
// child: Padding(
// padding: const EdgeInsets.all(8),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// TextButton.icon(
// onPressed: _selectDate,
// icon: const Icon(Icons.calendar_month),
// label: const Text('Select Date of Birth'),
// ),
// Text(dateOfBirth == null
// ? 'No date chosen'
// : getFormattedDate(dateOfBirth!)),
// ],
// ),
// ),
// ),
// ],
// ),
// )
