import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/main_view_model.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _urlController = TextEditingController();
  final _goldElementController = TextEditingController();
  final _silverElementController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _fontSizeController = TextEditingController();
  final _premiumController = TextEditingController();
  final _dollarController = TextEditingController();

  final Map<String, TextEditingController> _mcControllers = {};
  final List<String> _mcKeys = [
    'Mc100g', 'Mc50g', 'Mc31.10g', 'Mc20g', 'Mc10g',
    'Mc5g', 'Mc2.5g', 'Mc1g', 'Mc72g', 'Mc36g',
    'Mc18g', 'Mc8g', 'Mc7.2g', 'Mc3.6g', 'Mc1.8g', 'Mc0.9g'
  ];

  @override
  void initState() {
    super.initState();
    for (var key in _mcKeys) {
      _mcControllers[key] = TextEditingController();
    }
    _loadSettings();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _goldElementController.dispose();
    _silverElementController.dispose();
    _companyNameController.dispose();
    _fontSizeController.dispose();
    _premiumController.dispose();
    _dollarController.dispose();
    for (var controller in _mcControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    
    final model = context.read<MainViewModel>();
    
    setState(() {
      _urlController.text = prefs.getString('GoldUrl') ?? '';
      _goldElementController.text = prefs.getString('GoldElement') ?? '';
      _silverElementController.text = prefs.getString('SilverElement') ?? '';
      _companyNameController.text = prefs.getString('Company') ?? 'VERSAY JEWELLERY';
      _fontSizeController.text = prefs.getString('FontSize') ?? '20';
      _premiumController.text = (prefs.getDouble('Premium') ?? 10.0).toString();
      _dollarController.text = (prefs.getDouble('Dollar') ?? 0.305).toString();
      
      for (var key in _mcKeys) {
        double value = prefs.getDouble(key) ?? model.mcValues[key] ?? 0.0;
        _mcControllers[key]!.text = value.toString();
      }
    });
  }

  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('GoldUrl', _urlController.text);
    await prefs.setString('GoldElement', _goldElementController.text);
    await prefs.setString('SilverElement', _silverElementController.text);
    await prefs.setString('Company', _companyNameController.text);
    await prefs.setString('FontSize', _fontSizeController.text);
    await prefs.setDouble('Premium', double.tryParse(_premiumController.text) ?? 10.0);
    await prefs.setDouble('Dollar', double.tryParse(_dollarController.text) ?? 0.305);
    
    for (var key in _mcKeys) {
      double val = double.tryParse(_mcControllers[key]!.text) ?? 0.0;
      await prefs.setDouble(key, val);
    }
    
    if (mounted) {
      await context.read<MainViewModel>().loadSettings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully!'),
            backgroundColor: Color(0xFF1E3C72),
            duration: Duration(seconds: 2),
          ),
        );
        // Switch to the Home tab to show reloaded data
        final mainScreenState = context.findAncestorStateOfType<MainScreenState>();
        mainScreenState?.switchToTab(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSettingCard(
              title: "General Configuration",
              icon: Icons.storefront_rounded,
              children: [
                _buildTextField("Company Name", _companyNameController, Icons.business),
                const SizedBox(height: 16),
                _buildTextField("Font Size", _fontSizeController, Icons.format_size, isNumber: true),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField("Premium", _premiumController, Icons.add_circle_outline, isNumber: true)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField("Dollar", _dollarController, Icons.attach_money, isNumber: true)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingCard(
              title: "Data Sources",
              icon: Icons.data_object_rounded,
              children: [
                _buildTextField("Target URL", _urlController, Icons.link, isUrl: true),
                const SizedBox(height: 16),
                _buildTextField("Gold JS Element", _goldElementController, Icons.javascript_rounded),
                const SizedBox(height: 16),
                _buildTextField("Silver JS Element", _silverElementController, Icons.javascript_rounded),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingCard(
              title: "MC Values",
              icon: Icons.calculate_rounded,
              children: [
                for (int i = 0; i < _mcKeys.length; i += 2)
                  Padding(
                    padding: EdgeInsets.only(bottom: i + 2 >= _mcKeys.length ? 0 : 16),
                    child: Row(
                      children: [
                        Expanded(child: _buildTextField(_mcKeys[i], _mcControllers[_mcKeys[i]]!, Icons.monetization_on_outlined, isNumber: true)),
                        const SizedBox(width: 16),
                        if (i + 1 < _mcKeys.length)
                          Expanded(child: _buildTextField(_mcKeys[i + 1], _mcControllers[_mcKeys[i + 1]]!, Icons.monetization_on_outlined, isNumber: true))
                        else
                          Expanded(child: const SizedBox()),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: const Color(0xFFD4AF37).withOpacity(0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _saveSettings,
              child: const Text('SAVE SETTINGS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF1E3C72), size: 24),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3C72))),
              ],
            ),
            const SizedBox(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false, bool isUrl = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : (isUrl ? TextInputType.url : TextInputType.text),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E3C72), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
