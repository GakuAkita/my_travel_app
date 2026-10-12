import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../components/WhiteMarkdownBody.dart';
import '../../../../../data/model/itinerary_section/itinerary_section.dart';

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
    if (protocolMatch != null && protocolMatch.group(0) != 'https://' && protocolMatch.group(0) != 'http://') {
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('URLを開けませんでした: $href'), duration: const Duration(seconds: 3)));
        }
      }
    } catch (e) {
      print('URL起動エラー: $e (URL: $href)');
      // エラー時にもスナックバーを表示
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('URL起動エラー: $href'), duration: const Duration(seconds: 3)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (itiSection) {
      case MarkdownSection():
        final markdown = itiSection as MarkdownSection;
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          /* タイトルから本文まで(見出し・改行をまたいで)まとめて選択できるようにする */
          child: SelectionArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (markdown.title != "")
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: colorScheme.primary, width: 4)),
                    ),
                    child: Text(markdown.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  ),
                if (markdown.content != "")
                  WhiteMarkdownBody(
                    data: markdown.content,
                    onTapLink: (text, href, title) => _handleLinkTap(context, href),
                  ),
              ],
            ),
          ),
        );

      case TableSection():
        final table = itiSection as TableSection;
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.6)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectionArea(
              child: Table(
                columnWidths: {
                  for (int i = 0; i < table.tableData.flexes.length; i++)
                    i: FlexColumnWidth(table.tableData.flexes[i].toDouble()),
                },
                border: TableBorder.symmetric(inside: BorderSide(color: colorScheme.primary.withValues(alpha: 0.3))),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  // ヘッダー行
                  TableRow(
                    decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.15)),
                    children: [
                      for (int i = 0; i < table.tableData.header.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          child: Text(
                            table.tableData.header[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w700, color: colorScheme.primary),
                          ),
                        ),
                    ],
                  ),
                  // データ行
                  for (final row in table.tableData.tableCells)
                    TableRow(
                      children: [
                        for (int i = 0; i < table.tableData.header.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: WhiteMarkdownBody(
                              data: row.length > i ? row[i] : '',
                              onTapLink: (text, href, title) => _handleLinkTap(context, href),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );

      case SpaceSection():
        return const SizedBox(height: 30);

      default:
        return const Text("Invalid");
    }
  }
}
