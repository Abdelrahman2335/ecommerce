import 'package:ecommerce/features/address/presentation/manager/address_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:ecommerce/core/di/injection.dart';
import 'package:ecommerce/core/network/api_config.dart';

class LocationMapPreview extends StatelessWidget {
  const LocationMapPreview({
    super.key,
    required this.mediaQuery,
    required this.theme,
    required this.state,
    required this.onContinue,
  });

  final AddressState state;
  final VoidCallback onContinue;
  final Size mediaQuery;
  final Color theme;

  @override
  Widget build(BuildContext context) {
    final tileUrl = getIt<ApiConfig>().osmTileUrl;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          const Gap(70),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            height: mediaQuery.height * 0.27,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 129, 129, 129).withAlpha(140),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(-2, 3),
                  ),
                ],
                border: Border.all(
                  color: theme.withAlpha(20),
                )),
            child: FlutterMap(
                options: MapOptions(
                  /// The initial center is the user location
                  initialCenter: state.userLocation!,
                  initialZoom: 16,

                  /// making the map fixed
                  // maxZoom: 16,
                  // minZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate: tileUrl,
                    userAgentPackageName: 'com.example.ecommerce',
                  ),
                  MarkerLayer(markers: [
                    Marker(
                        point: state.userLocation!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          color: Colors.red,
                          Icons.location_pin,
                        ))
                  ])
                ]),
          ),
          Container(
            height: mediaQuery.height * 0.1,
            width: mediaQuery.width * 0.8,
            padding: EdgeInsets.only(right: 20, top: 34),
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: theme,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: onContinue,
              child: const Text(
                "Continue",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
