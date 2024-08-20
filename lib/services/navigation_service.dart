import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hero_chat/pages/hero_login.dart';
import 'package:hero_chat/pages/hero_register.dart';
import 'package:hero_chat/pages/home_page.dart';
import 'package:hero_chat/pages/login_page.dart';
import 'package:hero_chat/pages/register_page.dart';
import 'package:path/path.dart';

class NavigationService{
  late GlobalKey<NavigatorState> _navigatorKey;

  final Map<String,Widget Function(BuildContext)> _routes = {
    '/login': (context) => HeroLogin(),
    '/register': (context) => HeroRegister(),
    '/home': (context) => HomePage(),
  };

  GlobalKey<NavigatorState>? get navigatorKey{
    return _navigatorKey;
  }

  Map<String,Widget Function(BuildContext)> get routes{
    return _routes;
  }

  NavigationService(){
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  void push(MaterialPageRoute route){
    _navigatorKey.currentState?.push(route);
  }

  void pushNamed(String routeName){
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName){
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack(){
    _navigatorKey.currentState?.pop();
  }
}