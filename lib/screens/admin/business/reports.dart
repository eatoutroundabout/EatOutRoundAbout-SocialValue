import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/social_value.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';


class ViewSocialValueReports extends StatelessWidget {
  final SocialValue? socialValue;
  final BusinessProfile? businessProfile;
  final bool? isMyBusinessProfile;

  ViewSocialValueReports({this.socialValue, this.businessProfile, this.isMyBusinessProfile});


  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      appBar: AppBar(
          title: Image.asset('assets/images/applogo.png',
              height: AppBar().preferredSize.height - 15)),
      body:
        DefaultTabController(length: 3, child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Heading(title: 'SOCIAL VALUE REPORT'),
            SizedBox(height: 10),
            TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: primaryColor,
              tabs: [
                Tab(text: 'UN Goals'),
                Tab(text: 'UK Goals'),
                Tab(text: 'Other'),
              ],
            ),
            SizedBox(height: 15),
            Expanded(
              child: Container(
                child: TabBarView(
                  children: [
                    unGoals(),
                    ukGoals(),
                    other(),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
    );
  }

  unGoals() {
    return
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(padding),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    <Widget>[
                                      Image.asset('assets/images/un_poverty.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '1. End poverty',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xffE5233C),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('24', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold,
                                        fontSize: 30)),
                                      Text(
                                        'number of meals out supported for the elderly',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                            ],
                          ),
                        ),
                      ]
                  ),
                  SizedBox(width: 25),
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    <Widget>[
                                      Image.asset('assets/images/un_zero_hunger.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '2. Zero hunger',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xffDEA739),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('208', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'subsidised meals out',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                            ],
                          ),
                        ),
                      ]
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    <Widget>[
                                      Image.asset('assets/images/un_zero_hunger.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '3. Good health & wellbeing',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xff50A34A),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('231', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'social meals out',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                            ],
                          ),
                        ),
                      ]
                  ),
                  SizedBox(width: 25),
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Image.asset('assets/images/un_education.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '4. Quality education',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xffC61A2D),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('3', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'hours of tech careers education in schools',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Image.asset('assets/images/un_gender_equality.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '5. Gender equality',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xffEE402B),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('£4,800', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'investment with female founders',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                      Text('3', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'hours female role modelling in schools for girls in tech',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                  SizedBox(width: 25),
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Image.asset('assets/images/un_decent_work.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '8. Decent work & economic growth',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xffA31B44),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),


                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('51', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'hospitality jobs supported',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                      Text('6X', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'multiplier effect',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                      Text('£12,776', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'econmic impact value',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                ],
              ),

              SizedBox(height: 25),
              Row(
                children: [
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Image.asset('assets/images/un_innovation.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '9. Industry, innovation & infrastructure',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xffF26A2D),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('£508', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'towards sustainable innovation',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                  SizedBox(width: 25),
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Image.asset('assets/images/un_reduced_inequalities.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '10. Reduced inequalities',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 18, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xffE01482),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('£4,800', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'supporting female founder business',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Image.asset('assets/images/un_sustainable_cities.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '11. Sustainable cities & communities',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 18, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xffF89D29),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('£12,777', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'investment into',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                      Text('3', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'local towns',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                  SizedBox(width: 25),
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Image.asset('assets/images/un_responsible_consumption.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '12. Responsible consumption & production',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xffC08D2C),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('12', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'local suppliers supported',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                            fontSize: 16, color: primaryColor
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Image.asset('assets/images/un_climate_action.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '13. Climate action',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xff407F46),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'Working together towards greener hospitality',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                  SizedBox(width: 25),
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Image.asset('assets/images/un_life_below_water.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '14. Life below water',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xff2097D4),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'incentivising sustainable sourcing in hospitality',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Image.asset('assets/images/un_life_on_land.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '15. Life on land',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xff5ABB47),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('300', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'incentivising sustainable sourcing of meat, dairy, fruit & veg in hospitality',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                  SizedBox(width: 20),
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Image.asset('assets/images/un_partnerships.png', height: 75),
                                      SizedBox(height: 10),
                                      Text(
                                        '17. Partnerships for the goals',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    color: Color(0xff114A6B),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(

                                        'Bringing together the public and private sector',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),

                ],
              ),
            ],
          ),
        ),
      );
  }

  ukGoals() {
    return
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(padding),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(

                            children: [

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text(
                                        'Theme 1',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Covid-19 Recovery',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.teal.shade400,
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('3', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'hospitality venues supported',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                  SizedBox(width: 25),
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(

                            children: [

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text(
                                        'Theme 2',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Tackling economic inequality',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.teal.shade400,
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('3', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'independent businesses supported',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(

                            children: [

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text(
                                        'Theme 3',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Fighting climate change',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.teal.shade400,
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('3', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'Thanks to your support, we are working on this',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                  SizedBox(width: 25),
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(

                                child:

                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text(
                                        'Theme 4',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Equal opportunity',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.teal.shade400,
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('3', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'Support of female founded enterprise',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                ],
              ),

              Row(
                children: [
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(

                            children: [

                              Container(
                                child:

                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text(
                                        'Theme 5',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                      Text('Wellbeing',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.teal.shade400,
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text('3', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold, fontSize: 30)),
                                      Text(
                                        'meals out',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                  SizedBox(width: 25),
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(

                                child:

                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text(
                                        'Economic impact',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.teal.shade400,
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text(
                                        'x6',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 30, color: redColor,
                                        ),
                                      ),
                                      Text(
                                        '£6,800',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: redColor,
                                        ),
                                      ),
                                      Text(
                                        'into local economies',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),
                                width: 175,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                ],
              )
            ],
          ),
        ),
      );
  }

  other() {
    return
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(padding),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(

                            children: [

                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text(
                                        'HB Clark',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 385,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Color(0xff173B64),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                              Container(
                                width: 175,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        bottom: Radius.circular(8.0))),
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text(
                                        'x6',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 30, color: redColor,
                                        ),
                                      ),
                                      Text(
                                        '£567',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: redColor,
                                        ),
                                      ),
                                      Text(
                                        'into local HB Clark venues',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),

                              ),
                              SizedBox(height: 20),
                              Container(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text(
                                        'All venues',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16, color: Colors.white,
                                        ),
                                      ),
                                    ]),
                                width: 385,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Color(0xff173B64),
                                    borderRadius:
                                    BorderRadius.vertical(
                                        top: Radius.circular(8.0))),
                              ),
                              Container(
                                width: 175,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.vertical(
                                        bottom: Radius.circular(8.0))),
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text(
                                        'x6',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 30, color: redColor,
                                        ),
                                      ),
                                      Text(
                                        '£567',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: redColor,
                                        ),
                                      ),
                                      Text(
                                        'into local HB Clark venues',
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 16, color: primaryColor,
                                        ),
                                      ),
                                    ]),

                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                ],
              )
            ],
          ),
        ),
      );


}}