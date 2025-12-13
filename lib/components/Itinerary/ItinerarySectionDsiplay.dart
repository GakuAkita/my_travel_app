import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/ItinerarySection.dart';
import 'package:my_travel_app/components/WhiteMarkdownBody.dart';
import 'package:my_travel_app/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../BasicText.dart';

class ItinerarySectionDisplay extends StatelessWidget {
  final ItinerarySection itiSection;

  const ItinerarySectionDisplay({required this.itiSection, super.key});

  /// URLを正規化して起動可能な形式に修正する
  /// 例: httpsadf://example.com -> https://example.com
  String _normalizeUrl(String url) {
    // 不正なプロトコルを修正（httpsadf:// -> https://）
    if (url.startsWith('httpsadf://')) {
      return url.replaceFirst('httpsadf://', 'https://');
    }
    if (url.startsWith('httpadf://')) {
      return url.replaceFirst('httpadf://', 'http://');
    }
    // その他の一般的なプロトコルエラーを修正
    final protocolMatch = RegExp(r'^https?[a-z]+://').firstMatch(url);
    if (protocolMatch != null &&
        protocolMatch.group(0) != 'https://' &&
        protocolMatch.group(0) != 'http://') {
      // httpsXX:// のような形式を https:// に修正
      url = url.replaceFirst(protocolMatch.group(0)!, 'https://');
    }
    return url;
  }

  Future<void> _handleLinkTap(BuildContext context, String? href) async {
    if (href == null) return;

    print("Pressed:$href");

    try {
      // URLを正規化
      final normalizedUrl = _normalizeUrl(href);
      final uri = Uri.parse(normalizedUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('起動できない URL: $href (正規化後: $normalizedUrl)');
        // スナックバーで元のURLを表示
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('URLを開けませんでした: $href'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('URL起動エラー: $e (URL: $href)');
      // エラー時にもスナックバーを表示
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('URL起動エラー: $href'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return itiSection.type == ItinerarySectionType.markdown
        ? Column(
          children: [
            if (itiSection.title != "")
              Row(
                children: [
                  Expanded(
                    child: Text(
                      itiSection.title,
                      style: TextStyle(fontSize: 25),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ) /* まあこれ使うやついないかもな。 */,
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: WhiteMarkdownBody(
                    data: itiSection.content!,
                    onTapLink:
                        (text, href, title) => _handleLinkTap(context, href),
                  ),
                ),
              ],
            ),
          ],
        )
        : itiSection.type == ItinerarySectionType.defaultTable
        ? Table(
          columnWidths: {
            for (int i = 0; i < itiSection.tableData!.flexes.length; i++)
              i: FlexColumnWidth(itiSection.tableData!.flexes[i].toDouble()),
          },
          border: TableBorder.all(color: Theme.of(context).colorScheme.primary),
          children: [
            // ヘッダー行
            TableRow(
              children: [
                for (int i = 0; i < itiSection.tableData!.header.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: BasicText(text: itiSection.tableData!.header[i]),
                    ),
                  ),
              ],
            ),
            // データ行
            for (final row in itiSection.tableData!.tableCells)
              TableRow(
                children: [
                  for (int i = 0; i < itiSection.tableData!.header.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: WhiteMarkdownBody(
                        data: row.length > i ? row[i] : '',
                        onTapLink:
                            (text, href, title) =>
                                _handleLinkTap(context, href),
                      ),
                    ),
                ],
              ),
          ],
        )
        : itiSection.type == ItinerarySectionType.space
        /** @TODO
     * 空白smallとbigとかで変えたほうがいいかもな。まあとりあえずはこれで。
     * */
        ? SizedBox(height: 30)
        : Text("Unknown Type..");
  }
}
