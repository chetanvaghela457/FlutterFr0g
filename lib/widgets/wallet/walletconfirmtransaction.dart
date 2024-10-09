import 'dart:async';

import 'package:action_slider/action_slider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fr0gsite/chainactions/chainactions.dart';
import 'package:fr0gsite/config.dart';
import 'package:fr0gsite/datatypes/globalstatus.dart';
import 'package:fr0gsite/datatypes/walletstatus.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class WalletConfirmTransaction extends StatefulWidget {
  const WalletConfirmTransaction(
      {super.key, required this.callback, required this.sendtoaccount});
  final Function callback;
  final Account sendtoaccount;

  @override
  State<WalletConfirmTransaction> createState() =>
      _WalletConfirmTransactionState();
}

class _WalletConfirmTransactionState extends State<WalletConfirmTransaction> {
  ActionSliderController actionslidercontroller = ActionSliderController();
  Color backgroundcolorslider = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(color: backgroundcolorslider, width: 2),
              color: AppColor.niceblack,
            ),
            child: Center(
                child: Column(
              children: [
                AutoSizeText(
                  AppLocalizations.of(context)!.confirm,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  minFontSize: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    "${Provider.of<WalletStatus>(context, listen: false).amount} ${AppConfig.systemtoken} -> ${widget.sendtoaccount.accountName}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    minFontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ActionSlider.standard(
                    sliderBehavior: SliderBehavior.stretch,
                    controller: actionslidercontroller,
                    width: 300.0,
                    backgroundColor: backgroundcolorslider,
                    toggleColor: Colors.white,
                    action: (controller) async {
                      controller.loading();

                      double parsedamount = double.parse(
                          Provider.of<WalletStatus>(context, listen: false)
                              .amount);

                      String amountinformat =
                          "${parsedamount.toStringAsFixed(4)} ${AppConfig.systemtoken}";

                      Chainactions()
                        ..setusernameandpermission(
                            Provider.of<GlobalStatus>(context, listen: false)
                                .username,
                            Provider.of<GlobalStatus>(context, listen: false)
                                .permission)
                        ..sendtoken(
                                Provider.of<GlobalStatus>(context,
                                        listen: false)
                                    .username,
                                Provider.of<WalletStatus>(context,
                                        listen: false)
                                    .sendtoaccount
                                    .accountName,
                                amountinformat,
                                "Test")
                            .then((value) {
                          if (value) {
                            if (Provider.of<GlobalStatus>(context,
                                    listen: false)
                                .audionotifications) {
                              AudioPlayer audioPlayer = AudioPlayer();
                              audioPlayer.play(
                                  DeviceFileSource("assets/sounds/cash2.m4a"),
                                  volume: 0.5,
                                  mode: PlayerMode.lowLatency);
                            }

                            setState(() {
                              backgroundcolorslider = Colors.green;
                            });

                            controller.success();

                            Timer(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                              Timer(const Duration(seconds: 1), () {
                                widget.callback();
                              });
                            });
                          } else {
                            controller.failure();
                          }
                        });
                    },
                    child: Text(AppLocalizations.of(context)!.slidetoconfirm),
                  ),
                )
              ],
            ))),
      ),
    );
  }
}