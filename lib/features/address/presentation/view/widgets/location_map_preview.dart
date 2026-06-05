import 'package:ecommerce/core/di/injection.dart';
import 'package:ecommerce/core/network/api_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

class LocationMapPreview extends StatelessWidget {
  const LocationMapPreview({
    super.key,
    required this.userLocation,
    required this.onContinue,
    required this.onNewAddress,
  });

  final LatLng userLocation;
  final VoidCallback onContinue;
  final VoidCallback onNewAddress;

  @override
  Widget build(BuildContext context) {
    final tileUrl = getIt<ApiConfig>().osmTileUrl;
    final mediaQuery = MediaQuery.of(context).size;
    final theme = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
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
                  initialCenter: userLocation,
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate: tileUrl,
                    userAgentPackageName: 'com.example.ecommerce',
                  ),
                  MarkerLayer(markers: [
                    Marker(
                        point: userLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          color: Colors.red,
                          Icons.location_pin,
                        ))
                  ])
                ]),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 12,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  // minimumSize: Size(100, 40), /// Change the size of the button,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                  /// Change the padding of the button (the space inside the button)
                  /// Don't forget to change other buttons as well
                ),
                onPressed: onNewAddress,
                child: const Text("New Address"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: theme,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                onPressed: onContinue,
                child: const Text(
                  "Continue",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
