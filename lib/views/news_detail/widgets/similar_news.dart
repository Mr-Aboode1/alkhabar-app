import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/news_model.dart';
import '../../../data/repositories/news_repository.dart';
import '../news_detail_screen.dart';

class SimilarNewsWidget extends StatefulWidget {
  final String category;
  final String region;
  final String currentNewsId;

  const SimilarNewsWidget({
    super.key,
    required this.category,
    required this.region,
    required this.currentNewsId,
  });

  @override
  State<SimilarNewsWidget> createState() => _SimilarNewsWidgetState();
}

class _SimilarNewsWidgetState extends State<SimilarNewsWidget> {
  final NewsRepository _repo = NewsRepository();
  List<NewsModel> similarList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSimilar();
  }

  Future<void> _loadSimilar() async {
    final list = await _repo.getSimilarNews(
      category: widget.category,
      region: widget.region,
      currentId: widget.currentNewsId,
    );
    if (mounted) {
      setState(() {
        similarList = list;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || similarList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.similarNews,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...similarList.map((item) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: () {
              Get.off(() => NewsDetailScreen(news: item));
            },
          );
        }),
      ],
    );
  }
}
