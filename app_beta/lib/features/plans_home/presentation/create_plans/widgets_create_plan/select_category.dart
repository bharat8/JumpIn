import 'package:JumpIn/features/plans_home/domain/edit_public_plan_controller.dart';
import 'package:JumpIn/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({
    Key key,
  }) : super(key: key);

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  var _selectedCategory;
  final List<String> _categories = [
    'Outdoor Sports',
    'Indoor Sports and Games',
    'Health and Fitness',
    'Travel and Adventure',
    'Food and Drinks',
    'Games',
    'Academic interests',
    'Career/Professional interests',
    'Entertainment',
    'Hobbies',
    'Causes passionate about',
    'Fandoms',
    'Competitive Exams',
    'Miscellaneous '
  ];
  EditPublicPlanController editPublicPlanController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton(
        hint: Text('Select Category',
            style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal *
                    3)), // Not necessary for Option 1
        value: _selectedCategory,
        onChanged: (newValue) {
          editPublicPlanController.setCategory(newValue as String);
          setState(() {
            _selectedCategory = newValue;
          });
        },
        items: _categories.map((category) {
          return DropdownMenuItem(
            child: Text(category),
            value: category,
          );
        }).toList(),
      ),
    );
  }
}
