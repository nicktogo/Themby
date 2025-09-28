 import 'package:themby/src/common/domiani/site.dart';
import 'package:themby/src/features/emby/domain/image_props.dart';


String getImageUrl(Site site, String itemId, ImageProps? props) {
  // Validate site data before creating URI
  if (site.host == null || site.host!.isEmpty) {
    throw ArgumentError('Site host cannot be empty');
  }

  final queryParameters = {
    if (props?.maxHeight != null) 'maxHeight': props!.maxHeight.toString(),
    if (props?.maxWidth != null) 'maxWidth': props!.maxWidth.toString(),
    if (props?.quality != null) 'quality': props!.quality.toString(),
    if (props?.tag != null) 'tag': props!.tag,
  };

  return Uri(
    scheme: (site.scheme?.isNotEmpty == true) ? site.scheme! : 'http',
    host: site.host!,
    port: (site.port != null && site.port! > 0) ? site.port : null,
    path: '/emby/Items/$itemId/Images/${props?.type?.name ?? 'Primary'}',
    queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
  ).toString();
}

String getAvatarUrl(Site site) {
  // Validate site data before creating URI
  if (site.host == null || site.host!.isEmpty) {
    throw ArgumentError('Site host cannot be empty');
  }

  return Uri(
    scheme: (site.scheme?.isNotEmpty == true) ? site.scheme! : 'http',
    host: site.host!,
    port: (site.port != null && site.port! > 0) ? site.port : null,
    path: '/emby/Users/${site.userId ?? 'unknown'}/Images/Primary',
    queryParameters: (site.imageTag?.isNotEmpty == true) ? {'tag': site.imageTag!} : null,
  ).toString();
}