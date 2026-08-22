import 'package:geolocator/geolocator.dart';

/// Чем кончилась попытка определить местоположение.
///
/// Отказ — это не ошибка, а обычный исход: человек имеет право не давать
/// доступ к своему местоположению. Поэтому у каждого варианта есть внятное
/// продолжение, а не тупик с надписью «ошибка».
sealed class LocationOutcome {
  const LocationOutcome();
}

/// Координаты получены.
class LocationFound extends LocationOutcome {
  const LocationFound(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
}

/// Пользователь отказал. Можно спросить ещё раз позже.
class LocationDenied extends LocationOutcome {
  const LocationDenied();
}

/// Отказал навсегда: системный диалог больше не появится, нужны настройки.
class LocationDeniedForever extends LocationOutcome {
  const LocationDeniedForever();
}

/// Геолокация выключена на устройстве целиком.
class LocationServiceOff extends LocationOutcome {
  const LocationServiceOff();
}

/// Не успели или подвело железо.
class LocationFailed extends LocationOutcome {
  const LocationFailed(this.message);
  final String message;
}

/// Обёртка над geolocator.
///
/// Разрешение спрашивается ТОЛЬКО после того, как пользователь нажал кнопку и
/// прочитал, зачем это нужно. Системный диалог, выскочивший сам по себе на
/// первом экране, люди закрывают не читая — и отказывают навсегда, после чего
/// вернуть доступ можно только через настройки.
class GeoLocator {
  const GeoLocator();

  Future<LocationOutcome> current({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationServiceOff();
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      switch (permission) {
        case LocationPermission.denied:
          return const LocationDenied();
        case LocationPermission.deniedForever:
          return const LocationDeniedForever();
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          break;
        case LocationPermission.unableToDetermine:
          return const LocationDenied();
      }

      // Средней точности достаточно: нам нужен ближайший магазин, а не
      // положение с точностью до метра. Заодно экономит батарею и время.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: timeout,
        ),
      );
      return LocationFound(position.latitude, position.longitude);
    } on Object catch (e) {
      return LocationFailed(e.toString());
    }
  }

  Future<bool> openSettings() => Geolocator.openAppSettings();
}
