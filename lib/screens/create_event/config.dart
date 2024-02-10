import 'package:flutter/material.dart';

class CreateEventScreenConfig {
  final TextEditingController idController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  final TextEditingController participantsController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController dateEventController = TextEditingController();
  final TextEditingController dateEndController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController rewardController = TextEditingController();
  final TextEditingController logoUrlController = TextEditingController();

  void dispose() {
    idController.dispose();
    authorController.dispose();
    imageUrlController.dispose();
    captionController.dispose();
    participantsController.dispose();
    titleController.dispose();
    dateController.dispose();
    dateEventController.dispose();
    dateEndController.dispose();
    tagsController.dispose();
    rewardController.dispose();
    logoUrlController.dispose();
  }
}
