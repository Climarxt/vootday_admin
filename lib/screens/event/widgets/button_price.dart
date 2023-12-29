import 'package:vootday_admin/config/configs.dart';
import 'package:flutter/material.dart';

ButtonTheme buildButtonPrice(String price, String texte, BuildContext context) {
  return ButtonTheme(
    minWidth: double.infinity,
    child: OutlinedButton(
      onPressed: () {
        debugPrint('Received click');
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Text(price,style: AppTextStyles.displaySmallBold(context)),
            Text(texte, style: AppTextStyles.subtitleLargeGrey(context)),
          ],
        ),
      ),
    ),
  );
}
