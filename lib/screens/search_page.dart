import 'package:carousel_slider/carousel_slider.dart';
import 'package:delarship/Class/cars.dart';
import 'package:delarship/screens/car_details.dart';
import 'package:delarship/state/appState/cubit/app_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController sher = TextEditingController();
  String searchQuery = '';
  List<CarModel> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCLogic, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCLogic.get(context);
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: sher,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Search by Brand or Model',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Colors.black, strokeAlign: 30, width: 2)),
                    ),
                    onSubmitted: (value) {
                      searchResults.clear();
                      String query = value.trim().toLowerCase();
                      searchResults = cubit.carsList
                          .where((car) =>
                              car.brandName.toLowerCase().contains(query) ||
                              car.model.toLowerCase().contains(query))
                          .toList();
                      setState(() {});
                    },
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                      print(
                          "#################################${cubit.carsList.length}");
                    },
                  ),
                ),
                searchResults.isNotEmpty
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        itemBuilder: (context, i) {
                          final images = searchResults[i].images;
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
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return CarDetails(
                                                  searchResults[i]);
                                            }));
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CarouselSlider.builder(
                                                itemCount: images.length,
                                                itemBuilder:
                                                    (context, itemIndex, _) {
                                                  return buildImage(
                                                      images[itemIndex]);
                                                },
                                                options: CarouselOptions(
                                                  viewportFraction: 1,
                                                  aspectRatio: 1.5,
                                                  onPageChanged:
                                                      (index, reason) {
                                                    setState(() {
                                                      if (i <
                                                          cubit.activeIndices
                                                              .length) {
                                                        cubit.activeIndices[i] =
                                                            index;
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              buildIndicator(
                                                  i, images.length, cubit),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${searchResults[i].brandName} ${searchResults[i].model}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Row(
                                                          children: [
                                                            const Icon(Icons
                                                                .calendar_month),
                                                            const SizedBox(
                                                                width: 4),
                                                            Text(searchResults[
                                                                    i]
                                                                .year
                                                                .toString()),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(
                                                          '${searchResults[i].price} EGP',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                      onPressed: () async {
                                                        await cubit
                                                            .addtoFavfromsc(i,
                                                                searchResults);
                                                      },
                                                      icon: cubit.favList
                                                              .contains(
                                                                  searchResults[
                                                                      i])
                                                          ? const Icon(
                                                              Icons.favorite,
                                                              color: Colors.red,
                                                            )
                                                          : const Icon(Icons
                                                              .favorite_border_outlined)),
                                                ],
                                              ),
                                            ],
                                          )))));
                        })
                    : const Center(
                        child: Text(
                          'No results found.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
          );
        });
  }
}

Widget buildIndicator(int index, int count, AppCLogic obj) {
  int activeIndex =
      (index < obj.activeIndices.length) ? obj.activeIndices[index] : 0;

  return AnimatedSmoothIndicator(
    activeIndex: activeIndex,
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
