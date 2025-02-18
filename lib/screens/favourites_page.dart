import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:delarship/screens/car_details.dart';
import 'package:delarship/state/appState/cubit/app_logic.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCLogic, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCLogic.get(context);
        return cubit.favList.isEmpty
            ? const Center(
                child: Text(
                  'No Cars Added To Favorites',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cubit.favList.length,
                      itemBuilder: (context, i) {
                        final car = cubit.favList[i];
                        final images = car.images;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.brown.withOpacity(0.3),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CarDetails(car),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            if (i <
                                                cubit.activeIndices.length) {
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
                                                '${car.brandName} ${car.model}',
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
                                                  Text(car.year.toString()),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${car.price} EGP',
                                                style: const TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            if (cubit.favList.contains(car)) {
                                              await cubit.removefromFav(i);
                                            } else {
                                              await cubit.addToFav(i);
                                            }
                                          },
                                          icon: Icon(
                                            cubit.favList.contains(car)
                                                ? Icons.favorite
                                                : Icons
                                                    .favorite_border_outlined,
                                            color: cubit.favList.contains(car)
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
      },
    );
  }

  Widget buildImage(String url) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(15),
            bottom: Radius.circular(8),
          ),
          child: Image.network(
            url,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
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
}
