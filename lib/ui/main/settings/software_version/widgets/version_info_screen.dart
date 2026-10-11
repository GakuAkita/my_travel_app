import 'package:flutter/material.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionInfoScreen extends StatefulWidget {
  const VersionInfoScreen({super.key});

  static const id = "version_info_screen";

  @override
  State<VersionInfoScreen> createState() => _VersionInfoScreenState();
}

class _VersionInfoScreenState extends State<VersionInfoScreen> {
  String _version = '';
  String _buildNumber = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
      _loading = false;
    });
  }

  Future<void> _launchUrl(String uri) async {
    final Uri _url = Uri.parse(uri);

    if (!await launchUrl(_url)) {
      throw Exception("Could not launch $uri");
    }
  }

  @override
  Widget build(BuildContext context) {
    const String githubUrl = "https://github.com/GakuAkita/my_travel_app";
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: TopAppBar(title: "バージョン情報", automaticallyImplyLeading: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 16),
                const Center(child: Image(image: AssetImage("assets/images/public_world.png"), width: 80)),
                const SizedBox(height: 16),
                Center(
                  child: Text("Version $_version", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 24),
                Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      _buildInfoTile(Icons.tag, "バージョン", _version),
                      const Divider(height: 1, indent: 56),
                      _buildInfoTile(Icons.build_outlined, "ビルド番号", _buildNumber),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: Icon(Icons.code, color: colorScheme.primary),
                        title: const Text("ソースコード (GitHub)"),
                        subtitle: Text(githubUrl, style: TextStyle(color: colorScheme.primary)),
                        trailing: Icon(Icons.open_in_new, color: colorScheme.onSurfaceVariant),
                        onTap: () => _launchUrl(githubUrl),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(label),
      trailing: Text(value, style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant)),
    );
  }
}
