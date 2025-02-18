import 'package:carousel_slider/carousel_slider.dart';
import 'package:delarship/Class/cars.dart';
import 'package:delarship/List/carlist.dart';
import 'package:delarship/state/appState/cubit/app_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarDetails extends StatefulWidget {
  final CarModel data;

  const CarDetails(this.data, {super.key});

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  Carlist hCarList = Carlist();
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = (widget.data.images ?? [])
        .cast<String>(); 
    final brandName = widget.data.brandName ?? 'Unknown Brand';
    final model = widget.data.model ?? 'Unknown Model';
    final year = widget.data.year ?? 'Unknown Year';
    final price = widget.data.price ?? 'Unknown Price';
    final description = widget.data.description ?? 'No description available';

    return BlocProvider(
      create: (context) => AppCLogic(),
      child: BlocConsumer<AppCLogic, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCLogic.get(context);

          return Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
              backgroundColor: Colors.black,
              centerTitle: true,
              title: Image.asset(
                'assets/images/logo.jpg',
                scale: 2,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (images.isNotEmpty)
                          Column(
                            children: [
                              CarouselSlider.builder(
                                itemCount: images.length,
                                itemBuilder: (context, index, _) {
                                  return GestureDetector(
                                    onTap: () {
                                      openImageGallery(context, images, index);
                                    },
                                    child: buildImage(images[index]),
                                  );
                                },
                                options: CarouselOptions(
                                  viewportFraction: 1,
                                  aspectRatio: 1.5,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      activeIndex = index;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              buildIndicator(activeIndex, images.length),
                            ],
                          )
                        else
                          const Center(
                            child: Text(
                              'No images available',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Text(
                          brandName,
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          model,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month),
                            const SizedBox(width: 4),
                            Text(year.toString()),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Price',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$price EGP',
                          style: const TextStyle(fontSize: 25),
                        ),
                        const SizedBox(height: 25),
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'Car Description',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Card(
                          color: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              description,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Center(
                          child: MaterialButton(
                            minWidth: 400,
                            onPressed: () {
                              cubit.mess('Waiting For You !!!');
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.black,
                            child: const Text(
                              'Reserve',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildIndicator(int index, int count) {
    return AnimatedSmoothIndicator(
      activeIndex: index,
      count: count,
      effect: const ExpandingDotsEffect(
        dotWidth: 15,
        activeDotColor: Colors.black,
        dotHeight: 15,
      ),
    );
  }

  Widget buildImage(String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8), bottom: Radius.circular(8)),
          child: Image.network(
            url,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void openImageGallery(BuildContext context, List<String> images, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: PhotoViewGallery.builder(
             backgroundDecoration: BoxDecoration(
              color: Colors.brown[100]
             ),

            itemCount: images.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                
                imageProvider: NetworkImage(images[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
              );
            },
            pageController: PageController(initialPage: index),
          ),
        ),
      ),
    );
  }
}
