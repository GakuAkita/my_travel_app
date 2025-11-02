import 'package:flutter/material.dart';
import 'package:my_travel_app/CommonClass/ItinerarySection.dart';
import 'package:my_travel_app/components/WhiteMarkdownBody.dart';
import 'package:my_travel_app/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../BasicText.dart';

class ItinerarySectionDisplay extends StatelessWidget {
  final ItinerarySection itiSection;
  const ItinerarySectionDisplay({required this.itiSection, super.key});

  @override
  Widget build(BuildContext context) {
    return itiSection.type == ItinerarySectionType.markdown
        ? Column(
          children: [
            if (itiSection.title != "")
              Row(
                children: [
                  Text(
                    itiSection.title,
                    style: TextStyle(fontSize: 25),
                  ) /* まあこれ使うやついないかもな。 */,
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: WhiteMarkdownBody(
                    data: itiSection.content!,
                    onTapLink: (text, href, title) async {
                      print("Pressed:$href");
                      if (href != null) {
                        final uri = Uri.parse(href);
                        try {
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            print('起動できない URL: $href');
                          }
                        } catch (e) {
                          print('URL起動エラー: $e');
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        )
        : itiSection.type == ItinerarySectionType.defaultTable
        ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Table(
            columnWidths: {
              for (int i = 0; i < itiSection.tableData!.flexes.length; i++)
                i: FlexColumnWidth(itiSection.tableData!.flexes[i].toDouble()),
            },
            border: TableBorder.all(
              color: Theme.of(context).colorScheme.primary,
            ),
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
                    for (
                      int i = 0;
                      i < itiSection.tableData!.header.length;
                      i++
                    )
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: WhiteMarkdownBody(
                          data: row.length > i ? row[i] : '',
                          onTapLink: (text, href, title) async {
                            print('リンクをタップ: $text -> $href');
                            if (href != null) {
                              final uri = Uri.parse(href);
                              try {
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  print('起動できない URL: $href');
                                }
                              } catch (e) {
                                print('URL起動エラー: $e');
                              }
                            }
                          },
                        ),
                      ),
                  ],
                ),
            ],
          ),
        )
        : itiSection.type == ItinerarySectionType.space
        /** @TODO
         * 空白smallとbigとかで変えたほうがいいかもな。まあとりあえずはこれで。
         * */
        ? SizedBox(height: 30)
        : Text("Unknown Type..");
  }
}
