import 'package:fr0gsite/widgets/globaltag/globaltag.dart';
import 'package:fr0gsite/widgets/infoscreens/notfoundpage.dart';
import 'package:fr0gsite/widgets/postviewer/postviewer.dart';
import 'package:fr0gsite/widgets/root.dart';
import 'package:fluro/fluro.dart';

import '../main.dart';
import 'infoscreens/loadingpleasewaitscreen.dart';

class Mainrouter {
  static final FluroRouter router = FluroRouter();
  static final Handler _handlerpostview = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          Postviewer(id: params['id'][0]));

  static final Handler _handlerglobaltag = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          GlobalTag(globaltagid: params['globaltagid'][0]));

  static final Handler _defaultHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => const Root());
  static final Handler _pageHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          fr0gsiteApp(page: params['page'][0]));
  static final Handler _notfoundpage = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const NotFoundPage());
  static final Handler _loadingpleasewaitscreen = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          const Loadingpleasewaitscreen());

  static void setupRouter() {
    router.define('/postviewer/:id',
        handler: _handlerpostview, transitionType: TransitionType.fadeIn);

    router.define('/globaltag/:globaltagid',
        handler: _handlerglobaltag, transitionType: TransitionType.fadeIn);

    router.define('/', handler: _defaultHandler);

    router.define('/:page',
        handler: _pageHandler, transitionType: TransitionType.none);

    router.notFoundHandler = _notfoundpage;

    router.define('loadingpleasewaitscreen', handler: _loadingpleasewaitscreen);

    //router.define('/notfound', handler: _notfoundpage);
  }
}