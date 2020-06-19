import 'package:dharma_deshana/provider/data_provider.dart';
import 'package:dharma_deshana/widgets/list/song_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class TypeItem extends StatelessWidget {
  final String category;
  final String type;
  final double height;

  TypeItem(this.category, this.type, this.height);

  void selectType(BuildContext ctx) {
    pushNewScreen(
      ctx,
      screen: SongList(
        category: category,
        type: type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String key = category + '-' + type;

    final DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);

    final List<String> images = dataProvider.getImagesForCategoryTypeKey(key);
    String image;
    List<String> collage;
    bool addCollage = false;

    if (images.length < 4) {
      image = images.first;
    } else {
      addCollage = true;
      collage = images.sublist(0, 4);
    }

    return NeumorphicButton(
      onClick: () {},
      pressed: false,
      duration: Duration(seconds: 0),
      minDistance: 5,
      drawSurfaceAboveChild: true,
      padding: EdgeInsets.zero,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          child: InkWell(
            highlightColor: Colors.lightBlueAccent.withOpacity(0.1),
            onTap: () => selectType(context),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      height: height * 0.7,
                      width: height * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(height * 0.05),
                        border: Border.all(
                          width: height * 0.015,
                          color: Colors.white,
                        ),
                      ),
                      child: !addCollage
                          ? AspectRatio(
                              aspectRatio: 1 / 1,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(height * 0.05),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(height * 0.05),
                              child: GridView.builder(
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: collage[index],
                                    width: height * 0.7 / 2,
                                    fit: BoxFit.fitHeight,
                                  );
                                },
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: height * 0.4,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: height * 0.01,
                                  mainAxisSpacing: height * 0.01,
                                ),
                                itemCount: 4,
                              ),
                            ),
                    ),
                  ),
                  Text(
                    type,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: height * 0.12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      style: NeumorphicStyle(
        color: Colors.transparent,
        surfaceIntensity: 0.4,
        depth: 7,
        shape: NeumorphicShape.convex,
        intensity: 30,
        shadowLightColor: Colors.transparent,
      ),
    );
  }
}
