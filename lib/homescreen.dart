import 'package:flutter/material.dart';

import 'model_class.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String inputString1 = '''
  [{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},
  [{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]
  ''';

  String inputString2 = '''
  [{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},
  {"0":{"id":8,"title":"Froyo"},"2":{"id":9,"title":"Éclair"},"3":{"id":10,"title":"Donut"}},
  [{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]
  ''';

  String input2Map='''{"0":{"id":1,"title":"Gingerbread"},"1":{"id":2,"title":"Jellybean"},"3":{"id":3,"title":"KitKat"}},''';
  String input2List='''{"0":{"id":8,"title":"Froyo"},"2":{"id":9,"title":"Éclair"},"3":{"id":10,"title":"Donut"}},
  [{"id":4,"title":"Lollipop"},{"id":5,"title":"Pie"},{"id":6,"title":"Oreo"},{"id":7,"title":"Nougat"}]]''';

  List<AndroidVersion?> result1 = [];
  List<AndroidVersion?> result2 = [];

  List<AndroidVersion?> result21=[];
  List<AndroidVersion?> result22=[];

  bool showOne=true;
  @override
  void initState() {
     result1 = parseInputString(inputString1);
     result21 = parseInputString(input2Map);
     result22 = parseInputString(input2List);
  result2.addAll(result21);
  result2.addAll(result22);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCommonButton(text: "OutPut 1", onPressed: (){
                  print("Length: ${result1.length.toString()}  ${result2.length.toString()}");
                setState(() {
                  showOne=true;
                });
                }),
               const  SizedBox(width: 10,),
                _buildCommonButton(text: "OutPut 2", onPressed: (){
                  setState(() {
                    showOne=false;
                  });
                }),
              ],
            ),
            SizedBox(height: 10,),
            _buildDataView()
          ],
        ),
      ),
    );
  }

  Widget _buildCommonButton({
    required text,
    required VoidCallback onPressed,
    bool disabled = false,
    Icon? icon,
    String? imagePath,
    double borderRadius = 24,
    double fontSize = 16,
    Color color = Colors.amber,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: disabled
              ? Colors.grey
              : color, // Change this to your desired color
          borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child:  CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon ??
                  (imagePath != null
                      ? Image.asset(imagePath)
                      : const SizedBox()),
              const SizedBox(width: 5,),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontSize: fontSize, // Text size
                  fontWeight: FontWeight.bold, // Text weight
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  bool isInteger(String str) {
    return int.tryParse(str) != null;
  }
  List<AndroidVersion> parseInputString(String inputString) {
    print("start.......");
    List<AndroidVersion> versions = [];
    int currentIndex = 0;
    int lastNumber=0;
    int firstNumber=0;
    while (currentIndex < inputString.length) {
      int idIndex = inputString.indexOf('"id":', currentIndex);
      if (idIndex == -1) break;

      int commaIndex = inputString.indexOf(',', idIndex);
      if (commaIndex == -1) break;

      int titleIndex = inputString.indexOf('"title":', commaIndex);
      if (titleIndex == -1) break;

      int idValueStart = idIndex + '"id":'.length;
      int idValueEnd = inputString.indexOf(',', idValueStart);
      if (idValueEnd == -1) break;

      int titleValueStart = titleIndex + '"title":'.length + 1; // +1 to skip the opening quote
      int titleValueEnd = inputString.indexOf('"', titleValueStart);

      String idStr = inputString.substring(idValueStart, idValueEnd).trim();
      String titleStr = inputString.substring(titleValueStart, titleValueEnd).trim();

      int? id = int.tryParse(idStr);
      String? title = titleStr.isNotEmpty ? titleStr : null;

      if (id != null && title != null) {
        versions.add(AndroidVersion(id: id, title: title));
      }
      if(currentIndex==0)
      {
        RegExp integerPattern = RegExp(r'"(\d+)"');
        Iterable<RegExpMatch> matches = integerPattern.allMatches(inputString, currentIndex);

        for (var match in matches) {
          String integerStr = match.group(1)!;
          int? foundInteger = int.tryParse(integerStr);
          if (foundInteger != null) {
            print('Found integer: $foundInteger');
            lastNumber=foundInteger;
            if(lastNumber-firstNumber==2)
            {
              versions.add(AndroidVersion(id: null, title: ""));
              print("dif: ${lastNumber.toString()} ${firstNumber.toString()}");
            }

            firstNumber=lastNumber;
          }
        }
      }

      // Move currentIndex forward to continue searching
      currentIndex = titleValueEnd + 1;
    }

    return versions;
  }
  Widget _buildDataView(){
    return SizedBox(
      height: 300,
      width: 350,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount:showOne?result1.length: result2.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            color: Colors.blue[(index % 9 + 1) * 100], // Color for visual distinction
            child: Text(
              showOne? result1[index]!.title.toString()!: result2[index]!.title.toString()!,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          );
        },
      ),
    );
  }

}
