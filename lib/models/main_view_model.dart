import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_all/webview_all.dart';

class MainViewModel extends ChangeNotifier {
  String goldUrl = "";
  String goldElement = "";
  String silverElement = "";
  String companyName = "VERSAY JEWELLERY";
  double fontSize = 20.0;
  bool isSettingsLoaded = false;
  
  bool isVisible = true;
  double premium = 10.0;
  double dollar = 0.305;
  
  String time = "";
  String onzPrice = "0.0";
  String silverOnz = "0.0";
  
  // Calculated prices
  String tnPrice = "0.0";
  String fnPrice = "0.0";
  String nfPrice = "0.0";
  String ttPrice = "0.0";
  String toPrice = "0.0";
  String ePrice = "0.0";
  
  // Weight prices
  String hPrice = "0.0";
  String fPrice = "0.0";
  String ozPrice = "0.0";
  String twPrice = "0.0";
  String tePrice = "0.0";
  String fiPrice = "0.0";
  String tfPrice = "0.0";
  String oPrice = "0.0";
  String maPrice = "0.0";
  String muPrice = "0.0";
  String nmPrice = "0.0";
  String gPrice = "0.0";
  String lPrice = "0.0";
  String hlPrice = "0.0";
  String rlPrice = "0.0";
  String blPrice = "0.0";

  // MC values
  Map<String, double> mcValues = {
    'Mc100g': 12, 'Mc50g': 11, 'Mc31.10g': 10, 'Mc20g': 8, 'Mc10g': 7,
    'Mc5g': 6, 'Mc2.5g': 5, 'Mc1g': 4, 'Mc72g': 14, 'Mc36g': 8,
    'Mc18g': 6, 'Mc8g': 1.5, 'Mc7.2g': 1.5, 'Mc3.6g': 1.25, 'Mc1.8g': 1, 'Mc0.9g': 1
  };

  WebViewController? webViewController;
  Timer? _timer;

  MainViewModel() {
    loadSettings();
  }

  void toggleVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }
  
  void updatePremium(String val) {
    premium = double.tryParse(val) ?? 0.0;
  }
  void updateDollar(String val) {
    dollar = double.tryParse(val) ?? 0.0;
  }
  void updateMC(String key, String val) {
    mcValues[key] = double.tryParse(val) ?? 0.0;
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    goldUrl = prefs.getString('GoldUrl') ?? '';
    goldElement = prefs.getString('GoldElement') ?? '';
    silverElement = prefs.getString('SilverElement') ?? '';
    companyName = prefs.getString('Company') ?? 'VERSAY JEWELLERY';
    fontSize = double.tryParse(prefs.getString('FontSize') ?? '20') ?? 20.0;
    premium = prefs.getDouble('Premium') ?? 10.0;
    dollar = prefs.getDouble('Dollar') ?? 0.305;
    
    for (String key in mcValues.keys.toList()) {
      mcValues[key] = prefs.getDouble(key) ?? mcValues[key]!;
    }
    
    if (webViewController != null && goldUrl.isNotEmpty) {
      webViewController!.loadRequest(Uri.parse(goldUrl));
    }
    
    isSettingsLoaded = true;
    notifyListeners();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchDataFromWebView();
    });
  }

  Future<void> _fetchDataFromWebView() async {
    if (webViewController != null && goldElement.isNotEmpty) {
      try {
        final onz = await webViewController!.runJavaScriptReturningResult(goldElement);
        final silver = silverElement.isNotEmpty ? await webViewController!.runJavaScriptReturningResult(silverElement) : "0.0";
        
        onzPrice = onz.toString().replaceAll('"', '').trim();
        silverOnz = silver.toString().replaceAll('"', '').trim();
        
        _calculatePrices();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void _calculatePrices() {
    double result = double.tryParse(onzPrice) ?? 0;
    
    if (result > 0) {
      double tnine = (((result + premium) * 32.119) * dollar) / 1000;
      tnPrice = tnine.toStringAsFixed(3);
      
      double fnPriceDouble = ((tnine * 0.9999) / 0.999);
      fnPrice = fnPriceDouble.toStringAsFixed(3);
      
      nfPrice = ((tnine * 0.995) / 0.999).toStringAsFixed(3);
      
      double ttPriceDouble = (tnine * 0.917917);
      ttPrice = ttPriceDouble.toStringAsFixed(3);
      
      toPrice = (tnine * 0.875875).toStringAsFixed(3);
      ePrice = (tnine * 0.750750).toStringAsFixed(3);
      
      time = "${DateTime.now().toString().split('.')[0]}";
      
      hPrice = ((fnPriceDouble * 100) + mcValues['Mc100g']!).toStringAsFixed(3);
      fPrice = ((fnPriceDouble * 50) + mcValues['Mc50g']!).toStringAsFixed(3);
      ozPrice = ((fnPriceDouble * 31.10) + mcValues['Mc31.10g']!).toStringAsFixed(3);
      twPrice = ((fnPriceDouble * 20) + mcValues['Mc20g']!).toStringAsFixed(3);
      tePrice = ((fnPriceDouble * 10) + mcValues['Mc10g']!).toStringAsFixed(3);
      fiPrice = ((fnPriceDouble * 5) + mcValues['Mc5g']!).toStringAsFixed(3);
      tfPrice = ((fnPriceDouble * 2.5) + mcValues['Mc2.5g']!).toStringAsFixed(3);
      oPrice = ((fnPriceDouble * 1) + mcValues['Mc1g']!).toStringAsFixed(3);
      
      maPrice = ((ttPriceDouble * 72) + mcValues['Mc72g']!).toStringAsFixed(3);
      muPrice = ((ttPriceDouble * 36) + mcValues['Mc36g']!).toStringAsFixed(3);
      nmPrice = ((ttPriceDouble * 18) + mcValues['Mc18g']!).toStringAsFixed(3);
      gPrice = ((ttPriceDouble * 8) + mcValues['Mc8g']!).toStringAsFixed(3);
      lPrice = ((ttPriceDouble * 7.2) + mcValues['Mc7.2g']!).toStringAsFixed(3);
      hlPrice = ((ttPriceDouble * 3.6) + mcValues['Mc3.6g']!).toStringAsFixed(3);
      rlPrice = ((ttPriceDouble * 1.80) + mcValues['Mc1.8g']!).toStringAsFixed(3);
      blPrice = ((ttPriceDouble * 0.90) + mcValues['Mc0.9g']!).toStringAsFixed(3);
      
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
