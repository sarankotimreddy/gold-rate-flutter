import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_all/webview_all.dart';
import '../models/main_view_model.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final vm = context.read<MainViewModel>();
    vm.webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    if (vm.goldUrl.isNotEmpty) {
      vm.webViewController!.loadRequest(Uri.parse(vm.goldUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MainViewModel>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(vm.companyName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Hidden webview
          SizedBox(
            height: 1,
            width: 1,
            child: vm.webViewController != null 
                ? WebViewWidget(controller: vm.webViewController!) 
                : const SizedBox.shrink(),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTimeBadge(vm),
                        const SizedBox(height: 15),
                        
                        _buildTopGrid(vm),
                        const SizedBox(height: 20),
                        
                        if (vm.isVisible) _buildPremiumBlock(vm),
                        
                        if (vm.isVisible) const SizedBox(height: 10),
                        
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: vm.toggleVisibility,
                            icon: Icon(vm.isVisible ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF1E3C72)),
                            label: Text(vm.isVisible ? "Hide Premium" : "Show Premium", style: const TextStyle(color: Color(0xFF1E3C72), fontWeight: FontWeight.w600)),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        _buildBottomGrid(vm),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBadge(MainViewModel vm) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time_filled, color: Color(0xFFD4AF37), size: 20),
            const SizedBox(width: 8),
            Text(vm.time, style: TextStyle(fontSize: vm.fontSize * 0.7, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopGrid(MainViewModel vm) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFF3E5AB)]),
                ),
                child: const Text(
                  "LIVE MARKET RATES",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF5C4033), letterSpacing: 1.5),
                ),
              ),
              _buildModernRow("Gold Pure Us\$ :", vm.onzPrice, vm.fontSize, true),
              _buildModernRow("24K ( 999 ) :", vm.tnPrice, vm.fontSize, false),
              _buildModernRow("24K ( 999.9 ) :", vm.fnPrice, vm.fontSize, true),
              _buildModernRow("24K ( 995 ) :", vm.nfPrice, vm.fontSize, false),
              _buildModernRow("22K :", vm.ttPrice, vm.fontSize, true),
              _buildModernRow("21K :", vm.toPrice, vm.fontSize, false),
              _buildModernRow("18K :", vm.ePrice, vm.fontSize, true),
              _buildModernRow("Silver Onz \$ :", vm.silverOnz, vm.fontSize, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernRow(String title, String value, double fontSize, bool isAlternate) {
    return Container(
      color: isAlternate ? Colors.grey.shade50 : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: fontSize * 0.85, fontWeight: FontWeight.w600, color: Colors.black54)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              value,
              key: ValueKey<String>(value),
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xFF1E3C72)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBlock(MainViewModel vm) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Adjustments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E3C72))),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInputField("Premium", vm.premium.toString(), vm.updatePremium),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField("Dollar", vm.dollar.toString(), vm.updateDollar),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String initialValue, Function(String) onChanged) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildBottomGrid(MainViewModel vm) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF1E3C72), Color(0xFF2A5298)]),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text("Item", style: TextStyle(fontSize: vm.fontSize * 0.8, fontWeight: FontWeight.bold, color: Colors.white))),
                    Expanded(flex: 2, child: Text("MC", textAlign: TextAlign.center, style: TextStyle(fontSize: vm.fontSize * 0.8, fontWeight: FontWeight.bold, color: Colors.white))),
                    Expanded(flex: 3, child: Text("Amount", textAlign: TextAlign.right, style: TextStyle(fontSize: vm.fontSize * 0.8, fontWeight: FontWeight.bold, color: Colors.white))),
                  ],
                ),
              ),
              _buildEditableRow("100Gr", "McH", vm.hPrice, vm, true),
              _buildEditableRow("50Gr", "McF", vm.fPrice, vm, false),
              _buildEditableRow("31.10Gr", "McOz", vm.ozPrice, vm, true),
              _buildEditableRow("20Gr", "McTw", vm.twPrice, vm, false),
              _buildEditableRow("10Gr", "McTe", vm.tePrice, vm, true),
              _buildEditableRow("5Gr", "McFi", vm.fiPrice, vm, false),
              _buildEditableRow("2.50Gr", "McTf", vm.tfPrice, vm, true),
              _buildEditableRow("1Gr", "McO", vm.oPrice, vm, false),
              _buildEditableRow("72Gr", "McMa", vm.maPrice, vm, true),
              _buildEditableRow("36Gr", "McMu", vm.muPrice, vm, false),
              _buildEditableRow("18Gr", "McNm", vm.nmPrice, vm, true),
              _buildEditableRow("8Gr", "McG", vm.gPrice, vm, false),
              _buildEditableRow("7.20Gr", "McL", vm.lPrice, vm, true),
              _buildEditableRow("3.60Gr", "McHl", vm.hlPrice, vm, false),
              _buildEditableRow("1.80Gr", "McRl", vm.rlPrice, vm, true),
              _buildEditableRow("0.90Gr", "McBl", vm.blPrice, vm, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableRow(String title, String mcKey, String value, MainViewModel vm, bool isAlternate) {
    return Container(
      color: isAlternate ? Colors.grey.shade50 : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2, 
            child: Text(title, style: TextStyle(fontSize: vm.fontSize * 0.85, fontWeight: FontWeight.w600, color: Colors.black87))
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextFormField(
                initialValue: vm.mcValues[mcKey].toString(),
                onChanged: (val) => vm.updateMC(mcKey, val),
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontSize: vm.fontSize * 0.85, fontWeight: FontWeight.w600, color: const Color(0xFFD4AF37)),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
            )
          ),
          Expanded(
            flex: 3, 
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                value, 
                key: ValueKey(value),
                textAlign: TextAlign.right, 
                style: TextStyle(fontSize: vm.fontSize, fontWeight: FontWeight.bold, color: const Color(0xFF1E3C72))
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
        ]
      ),
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => launchUrl(Uri.parse('https://github.com/sarankotimreddy')),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.code_rounded, color: Colors.grey, size: 20),
              SizedBox(width: 8),
              Text.rich(
                TextSpan(
                  text: 'Developed by ',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                  children: [
                    TextSpan(text: 'SaranKotimreddy', style: TextStyle(color: Color(0xFF1E3C72), fontWeight: FontWeight.bold)),
                  ]
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}
