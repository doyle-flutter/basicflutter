// main.dart
//  - runApp(GetMaterialApp(home: GetXPage())); -> 수정
import 'package:flutter/material.dart';
import 'package:get/get.dart' as GetX;

import 'GetXHttpPage.dart'; // 전역으로 사용 될 Obx 를 좀 더 연관성 있게 사용하려면 as 를 통해 묶어주는 편이 좋습니다

class GetXPage extends StatelessWidget {

  // StateClassInstance GET
  final GetXState c = GetX.Get.put(GetXState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GetX - State"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: (){
              // [ Navigator ]
              // - push
              // --- (1) Widget
              GetX.Get.to(GetXHttpPage2());
              // --- (2) Name
              // GetX.Get.toNamed('/GetXHttpPage2');

              // - replacement
              // GetX.Get.off(GetXHttpPage2());

              // - removeAll
              // GetX.Get.offAll(GetXHttpPage2());
            }
          )
        ],
      ),
      body: Center(
        // [GetX . 1]
        // child: Text(c.obs.value.value.toString()), // staticValue

        // [GetX . 2] Obx -> setState 효과를 갖음
        child: GetX.Obx(() => Text(c.value.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: c.obs.value.increase,
      ),
    );
  }
}

// State Class instance
class GetXState extends GetX.GetxController{
  GetX.RxInt value = 0.obs; // .obs -- stateValue
  void increase() => this.value++;
}
