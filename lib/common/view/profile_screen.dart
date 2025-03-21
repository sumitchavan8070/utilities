import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:utilities/common/bottom_sheet/image_picker_drawer.dart';
import 'package:utilities/common/bottom_sheet/search_dropdown.dart';
import 'package:utilities/common/controller/get_city_controller.dart';
import 'package:utilities/common/controller/get_countries_controller.dart';
import 'package:utilities/common/controller/get_states_controller.dart';
import 'package:utilities/common/controller/profile_controller.dart';
import 'package:utilities/common/model/profile_model_data.dart';
import 'package:utilities/common_assets_path.dart';
import 'package:utilities/components/cached_image_network_container.dart';
import 'package:utilities/components/cupertino_date_picker.dart';
import 'package:utilities/components/enums.dart';
import 'package:utilities/components/gradding_app_bar.dart';
import 'package:utilities/components/image_cropper_function.dart';
import 'package:utilities/components/message_scaffold.dart';
import 'package:utilities/components/try_again.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/dio/http_apis.dart';
import 'package:utilities/form_fields/custom_text_fields.dart';
import 'package:utilities/form_fields/intl_text_field.dart';
import 'package:utilities/packages/intl_form_field/countries.dart';
import 'package:utilities/theme/app_box_decoration.dart';
import 'package:utilities/theme/app_colors.dart';
import 'package:utilities/validators/generic_validator.dart';
import 'package:utilities/validators/input_formatters.dart';
import 'package:utilities/validators/my_regex.dart';

final _profileController = Get.put(ProfileController());
final _getCountriesController = Get.put(GetCountriesController());
final _getStatesController = Get.put(GetStatesController());
final _getCityController = Get.put(GetCityController());

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passPortController = TextEditingController();
  final TextEditingController validUpToController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController alternatePhoneController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  TextEditingController searchController = TextEditingController();

  //  id Controllers
  final TextEditingController stateIdController = TextEditingController();
  final TextEditingController countryIdController = TextEditingController();
  final TextEditingController cityIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? selectedValue = "";

  String? altCountryCode;
  int? altMaxLength;

  String? altSelectedName;
  bool show = false;
  bool passportShow = false;

  String gender = "";
  String genderError = "";

  XFile? pickedImage;
  final picker = ImagePicker();

  List<String> filteredOptions = [];
  DateTime? selectedDate;
  String? selectedDateString;

  bool isLoadingData = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _profileController.getProfileData();
      await _getCountriesController.getCountries();

      final response = _profileController.state?.profile;
      _populateProfileData(response);
    });
  }

  void _populateProfileData(Profile? profile) async {
    firstNameController.text = profile?.name ?? "";
    lastNameController.text = profile?.lastName ?? "";
    dobController.text = profile?.birthDate ?? "";
    emailController.text = profile?.email ?? "";
    phoneController.text = profile?.phone ?? "";
    alternatePhoneController.text = profile?.alternatePhone ?? "";
    countryController.text = profile?.countriesName ?? "";
    stateController.text = profile?.stateName ?? "";
    cityController.text = profile?.cityName ?? "";
    altSelectedName = profile?.country ?? "India";
    cityIdController.text = profile?.cityId ?? "";
    stateIdController.text = profile?.stateId ?? "";
    countryIdController.text = profile?.countryId.toString() ?? "";
    setState(() {
      gender = profile?.gender ?? "";
      if (profile?.alternatePhone?.isNotEmpty == true) {
        show = true;
      }
    });

    debugPrint("here is the gender from the api response $gender");
    await _getStatesController.getStates(countyId: countryIdController.text);
    await _getCityController.getCities(stateId: stateIdController.text);
    setState(() {
      isLoadingData = false;
    });
  }

  Future getImage() async {
    documentPickerOptionsDrawer(
      context: context,
      onTapCamera: () async {
        context.pop();
        final image = await picker.pickImage(
          source: ImageSource.camera,
        );

        if (image?.path == null) {
          return;
        }

        final croppedImage = await imageCropperFunction(
          imagePath: image,
        );

        if (croppedImage == null) {
          return;
        }

        setState(() {
          pickedImage = croppedImage;
          debugPrint('Image update completed. ${croppedImage.path}');
        });
      },
      onTapGallery: () async {
        context.pop();
        final image = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (image?.path == null) {
          return;
        }

        final croppedImage = await imageCropperFunction(
          imagePath: image,
        );

        if (croppedImage == null) {
          return;
        }

        setState(() {
          pickedImage = croppedImage;
          debugPrint('Image update completed. ${croppedImage.path}');
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const GraddingAppBar(
          backButton: true,
          showActions: false,
        ),
        body: _profileController.obx(
              (state) {
            if (isLoadingData) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: kToolbarHeight),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: AppBoxDecoration.getBoxDecoration(
                          borderRadius: 14,
                          showShadow: false,
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: kToolbarHeight),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: CustomTextFormField(
                                      title: "First Name",
                                      hintText: "First Name",
                                      inputFormatter: [WhitespaceTextInputFormatter()],
                                      controller: firstNameController,
                                      validator: (value) {
                                        return GenericValidator.required(
                                          value: value?.trim(),
                                          message: "Enter First Name",
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Flexible(
                                    child: CustomTextFormField(
                                      title: "Last Name",
                                      inputFormatter: [WhitespaceTextInputFormatter()],
                                      hintText: "Last Name",
                                      controller: lastNameController,
                                      validator: (value) {
                                        return GenericValidator.required(
                                          value: value?.trim(),
                                          message: "Enter Last Name",
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        passportShow = !passportShow;
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          "Do you have passport",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: AppColors.primaryColor),
                                        ),
                                        const SizedBox(width: 6),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (passportShow) ...[
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: CustomTextFormField(
                                        title: "Passport Number",
                                        hintText: "UD124585",
                                        controller: passPortController,
                                        validator: (value) {
                                          return passportShow == true
                                              ? GenericValidator.required(
                                            value: value,
                                            message: "Enter passport number",
                                          )
                                              : null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Flexible(
                                      child: CustomTextFormField(
                                        title: "Valid Upto",
                                        hintText: "25/12/2028",
                                        controller: validUpToController,
                                        validator: (value) {
                                          return passportShow == true
                                              ? GenericValidator.required(
                                            value: value,
                                            message: "Enter card validity",
                                          )
                                              : null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gender",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                      color: AppColors.stormDust,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      _genderSelectionButton(
                                        gender,
                                        "male",
                                        CommonAssetPath.male,
                                        CommonAssetPath.activeMale,
                                        "Male",
                                      ),
                                      _genderSelectionButton(
                                        gender,
                                        "female",
                                        CommonAssetPath.female,
                                        CommonAssetPath.activeFemale,
                                        "Female",
                                      ),
                                    ],
                                  ),
                                  if (genderError != "")
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        genderError,
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: AppColors.cadmiumRed),
                                      ),
                                    )
                                ],
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () =>
                                    cupertinoCalenderDrawer(
                                      context: context,
                                      initialDate: DateTime.now().subtract(
                                        const Duration(days: 365 * 10), // 25 years ago
                                      ),
                                      startDate: DateTime.now().subtract(
                                        const Duration(days: 365 * 60), // 60 years ago
                                      ),
                                      endDate: DateTime.now().subtract(
                                        const Duration(days: 365 * 10),
                                      ),
                                      title: "Select Date",
                                      onSave: (date) {
                                        setState(() {
                                          selectedDate = date;
                                          selectedDateString =
                                              DateFormat('yyyy-MM-dd').format(date);
                                          dobController.text = selectedDateString!;
                                          debugPrint('$selectedDateString');
                                        });
                                      },
                                    ),
                                child: CustomTextFormField(
                                  validationMode: AutovalidateMode.always,
                                  enabled: false,
                                  title: "Date Of Birth",
                                  hintText: "Enter DOB",
                                  controller: dobController,
                                  validator: (value) {
                                    return GenericValidator.required(
                                      value: dobController.text,
                                      message: "Enter your birth date",
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                title: "Email",
                                hintText: "Enter Email",
                                controller: emailController,
                                validationMode: AutovalidateMode.always,
                                validator: (value) {
                                  return GenericValidator.required(
                                    value: value,
                                    message: "Enter Email",
                                  ) ??
                                      GenericValidator.regexMatch(
                                          value: value,
                                          regex: MyRegex.emailPattern,
                                          message: "Invalid Email");
                                },
                              ),
                              const SizedBox(height: 20),
                              IntlTextField(
                                title: "Phone Number",
                                showBorder: false,
                                controller: phoneController,
                                initialValue: state?.profile?.country,
                                enabled: false,
                                hintText: 'Mobile Number',
                              ),
                              if (!show) ...[
                                const SizedBox(height: 6),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        show = true;
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          "Add an alternate mobile number:",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: AppColors.primaryColor),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(Icons.add_circle_outlined,
                                            color: AppColors.primaryColor)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              if (show) ...[
                                const SizedBox(height: 20),
                                IntlTextField(
                                  title: "Alternate Phone Number",
                                  controller: alternatePhoneController,
                                  onCountryChanged: (value) {
                                    setState(() {
                                      altCountryCode = value.dialCode;
                                      altSelectedName = value.name;
                                      altMaxLength = value.maxLength;
                                    });
                                  },
                                  onChanged: (value) {
                                    if (alternatePhoneController.text.length != altMaxLength) {
                                      return;
                                    }
                                  },
                                  validator: (value) {
                                    return GenericValidator.required(
                                      value: value,
                                      message: "Enter Number",
                                    ) ??
                                        GenericValidator.checkLength(
                                          value: value,
                                          length: altMaxLength ??
                                              (getCountryCodeLength(
                                                  state?.profile?.country ?? "") ??
                                                  0),
                                          message: "Invalid Number",
                                        );
                                  },
                                  hintText: 'Alternate Mobile Number',
                                ),
                                const SizedBox(height: 6),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        show = false;
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          "Hide alternate mobile number:",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: AppColors.primaryColor),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(Icons.remove_circle,
                                            color: AppColors.primaryColor)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () =>
                                    changeCountry(
                                      hintText: "Select Country",
                                      data: _getCountriesController.state?.answers,
                                      onchange: (value) {
                                        countryController.text = value;
                                      },
                                      getNewData: (key) async {
                                        countryIdController.text = key;
                                        await _getStatesController.getStates(countyId: key);
                                        cityController.clear();
                                        stateController.clear();
                                        setState(() {});
                                      },
                                      context: context,
                                    ),
                                child: CustomTextFormField(
                                  title: "Country",
                                  hintText: "Select Country",
                                  controller: countryController,
                                  validationMode: AutovalidateMode.always,
                                  enabled: false,
                                  suffix: _getStatesController.isLoggingIn.value == true
                                      ? const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                      : const Icon(Icons.arrow_drop_down),
                                  validator: (value) {
                                    return GenericValidator.required(
                                      value: value,
                                      message: "Select Country",
                                    );
                                  },
                                ),
                              ),
                              if (_getStatesController.state?.answers?.isNotEmpty == true) ...[
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () =>
                                      changeCountry(
                                        hintText: "Select States",
                                        data: _getStatesController.state?.answers,
                                        onchange: (value) {
                                          stateController.text = value;
                                        },
                                        getNewData: (key) async {
                                          stateIdController.text = key;
                                          await _getCityController.getCities(stateId: key);

                                          setState(() {});
                                        },
                                        context: context,
                                      ),
                                  child: CustomTextFormField(
                                    title: "State",
                                    hintText: "Select Your State",
                                    controller: stateController,
                                    validationMode: AutovalidateMode.always,
                                    enabled: false,
                                    suffix: _getCityController.isLoggingIn.value == true
                                        ? const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                        : const Icon(Icons.arrow_drop_down),
                                    validator: (value) {
                                      return GenericValidator.required(
                                        value: value,
                                        message: "Select State",
                                      );
                                    },
                                  ),
                                ),
                              ],
                              if (_getStatesController.state?.answers?.isNotEmpty == true &&
                                  _getCityController.state?.answers?.isNotEmpty == true) ...[
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () =>
                                      changeCountry(
                                        hintText: "Select City",
                                        data: _getCityController.state?.answers,
                                        onchange: (value) {
                                          cityController.text = value;
                                        },
                                        getNewData: (key) {
                                          cityIdController.text = key;
                                        },
                                        context: context,
                                      ),
                                  child: CustomTextFormField(
                                    title: "City",
                                    hintText: "Select your city",
                                    controller: cityController,
                                    enabled: false,
                                    suffix: const Icon(Icons.arrow_drop_down),
                                    validator: (value) {
                                      return GenericValidator.required(
                                        value: value,
                                        message: "Select city",
                                      );
                                    },
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: kToolbarHeight + 20),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Hero(
                      tag: "profile-image",
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        padding: EdgeInsets.all(pickedImage == null ? 8 : 0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: pickedImage == null
                            ? ClipOval(
                          child: CachedImageNetworkContainer(
                            height: 100,
                            width: 100,
                            fit: BoxFit.contain,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            url: state?.profile?.imageUrl,
                            placeHolder: buildPlaceholder(
                              name: state?.profile?.name?[0],
                              context: context,
                            ),
                          ),
                        )
                            : Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.file(
                            File(pickedImage?.path ?? ''),
                            height: 100,
                            width: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 180,
                    right: 100,
                    top: 80,
                    child: GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: SvgPicture.asset(CommonAssetPath.upload),
                    ),
                  )
                ],
              ),
            );
          },
          onError: (error) =>
              TryAgain(
                onTap: () => _profileController.getProfileData(),
              ),
        ),
        floatingActionButton: isLoadingData == false
            ? Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery
                  .of(context)
                  .size
                  .width * 0.8, 42),
            ),
            onPressed: () async {
              if (gender == "") {
                setState(() {
                  genderError = "Select Gender";
                });
                debugPrint("error for gender:::::::  $gender");
              } else if (_formKey.currentState?.validate() == true) {
                setState(() {
                  genderError = "";
                });
                debugPrint(pickedImage.toString());
                await httpApi(
                  endpoint: APIEndPoints.updateProfileData,
                  image: pickedImage,
                  additionalFields: {
                    "name": firstNameController.text,
                    "email": emailController.text,
                    "last_name": lastNameController.text,
                    "alternate_phone": alternatePhoneController.text,
                    "alternate_country": altCountryCode ?? "",
                    "gender": gender,
                    "birth_date": selectedDateString ?? "",
                    "state_id": stateIdController.text,
                    "country_id": countryIdController.text,
                    "city_id": cityIdController.text,
                    "passport_number": passPortController.text,
                    "passport_expiry": validUpToController.text,
                  },
                ).then((value) {
                  Map<String, dynamic> responseBody = jsonDecode(value.body);
                  final status = responseBody['status'].toString();
                  debugPrint('status = $responseBody: $status');
                  if (status == "1") {
                    messageScaffold(
                      context: context,
                      content: "Profile Updated Successfully",
                      isTop: true,
                      messageScaffoldType: MessageScaffoldType.success,
                    );
                    _profileController.getProfileData();
                  }
                });
              } else {
                debugPrint("error");
              }
            },
            child: Text(
              "Update Profile",
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
            ),
          ),
        )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _genderSelectionButton(String selectedGender,
      String genderValue,
      String assetPath,
      String activeAssetPath,
      String label,) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          setState(() {
            gender = genderValue;
            debugPrint("error  $gender");
            genderError = "";
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: AppBoxDecoration.getBorderBoxDecoration(
            showShadow: false,
            color: gender == genderValue
                ? AppColors.primaryColor.withOpacity(0.1)
                : AppColors.magnolia,
            borderRadius: 10,
            borderColor: gender == genderValue
                ? AppColors.primaryColor.withOpacity(0.3)
                : selectedGender == genderValue
                ? AppColors.primaryColor.withOpacity(0.3)
                : Colors.transparent,
          ),
          height: 50,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                gender == genderValue ? activeAssetPath : assetPath,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color: gender == genderValue ? AppColors.primaryColor : Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
