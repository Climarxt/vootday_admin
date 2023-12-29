import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/screens/widgets/image_loader_card_event.dart';

class MosaiqueEventLargeCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String eventId;

  const MosaiqueEventLargeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.eventId,
  });

  @override
  State<MosaiqueEventLargeCard> createState() => _MosaiqueEventLargeCardState();
}

class _MosaiqueEventLargeCardState extends State<MosaiqueEventLargeCard> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _opacity = 1.0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double cardWidth = size.width * 0.2;
    double cardHeight = size.height * 0.2;
    return Bounceable(
      onTap: () => _navigateToEventScreen(context),
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 300),
        child: SizedBox(
          width: cardWidth,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: Center(
                child: _buildPost(
                    context, widget.imageUrl, cardWidth, cardHeight)),
          ),
        ),
      ),
    );
  }

  Widget _buildPost(
      BuildContext context, String imageUrl, double width, double height) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 700),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ImageLoaderCardEvent(
            imageUrl: imageUrl,
            width: width,
            height: height,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          buildText(context),
        ],
      ),
    );
  }

  Widget buildText(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 12,
      child: Text(
        widget.title,
        style: AppTextStyles.titlePost(context),
      ),
    );
  }

  void _navigateToEventScreen(BuildContext context) {
    GoRouter.of(context)
        .go('/calendar/event/${widget.eventId}', extra: widget.eventId);
  }
}
