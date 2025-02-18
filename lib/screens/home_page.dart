import 'package:carousel_slider/carousel_slider.dart';
import 'package:delarship/List/carlist.dart';
import 'package:delarship/List/logolist.dart';
import 'package:delarship/screens/car_details.dart';
import 'package:delarship/state/appState/cubit/app_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Carlist clist = Carlist();
  Logolist Carlogo = Logolist();
@override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCLogic, AppState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.black,));
        }
        var cubit = AppCLogic.get(context);

        if (cubit.activeIndices.length != cubit.carsList.length) {
          cubit.activeIndices = List.filled(cubit.carsList.length, 0);
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cubit.carsList.length,
                itemBuilder: (context, i) {
                  // print(cubit.favList.contains(cubit.carsList[i]));

                  final images = cubit.carsList[i].images ?? []; 
                  if (images.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'No images available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.brown.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return CarDetails(cubit.carsList[i]);
                            }));
                          },
                          child: Column(
                            children: [
                              CarouselSlider.builder(
                                itemCount: images.length,
                                itemBuilder: (context, itemIndex, _) {
                                  return buildImage(images[itemIndex]);
                                },
                                options: CarouselOptions(
                                  viewportFraction: 1,
                                  aspectRatio: 1.5,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      if (i < cubit.activeIndices.length) {
                                        cubit.activeIndices[i] = index;
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              buildIndicator(i, images.length, cubit),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${cubit.carsList[i].brandName} ${cubit.carsList[i].model}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_month),
                                            const SizedBox(width: 4),
                                            Text(cubit.carsList[i].year.toString()),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${cubit.carsList[i].price} EGP',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(onPressed: ()async{
                                    await cubit.addToFav(i);
                                  }, icon: cubit.favList.contains(cubit.carsList[i])?const Icon(Icons.favorite,color: Colors.red,): const Icon(Icons.favorite_border_outlined)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }


}

Widget buildIndicator(int index, int count, AppCLogic cubit) {
  return AnimatedSmoothIndicator(
    activeIndex: cubit.activeIndices[index],
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
    margin: const EdgeInsets.symmetric(horizontal: 5),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(15), bottom: Radius.circular(8)),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          },
        ),
      ),
    ),
  );
}
