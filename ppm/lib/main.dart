import 'dart:ffi';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:PPM/bloc/appDataBloc/bloc.dart';
import 'package:PPM/bloc/checkLoginBloc/bloc.dart';
import 'package:PPM/bloc/internetCheckBloc/bloc.dart';
import 'package:PPM/bloc/loginBloc/bloc.dart';
import 'package:PPM/bloc/loginBloc/loginBloc.dart';
import 'package:PPM/bloc/accountDataBloc/bloc.dart';
import 'package:PPM/bloc/simpleBlocDelegate.dart';
import 'package:flutter/material.dart';
import 'package:PPM/bloc/systemLanguage/bloc.dart';
import 'package:PPM/dataModel/appDataModel.dart';
import 'package:PPM/statePage.dart';
import 'package:PPM/typedef.dart';
import 'package:PPM/ui/appMain.dart';
import 'package:PPM/ui/login/signIn.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
    statusBarBrightness: Brightness.light,

    /// Only honored in iOS.
    statusBarIconBrightness: Brightness.dark,

    ///Only honored in Android version M and greater.
    systemNavigationBarIconBrightness: Brightness.dark,

    ///Only honored in Android versions O and greater.
  ));
  Bloc.observer = SimpleBlocObserver();
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    if (Platform.isAndroid) {
      FlutterDisplayMode.current.then((displayMode) {
        FlutterDisplayMode.setMode(displayMode);
        FlutterDisplayMode.setDeviceDefault();
        print(displayMode);
      });
    }
    //FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    //FlutterStatusbarcolor.setStatusBarColor(Colors.transparent,animate: true);
    //FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    //FlutterStatusbarcolor.setNavigationBarColor(Colors.white,animate: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              AppDataBloc(appDataModel: AppDataModel())
                ..add(AppDataEventGetData(0)),
        ),
        BlocProvider(
          create: (BuildContext context) => SystemLanguageBloc()
            ..add(SystemLanguageEventChange(
                systemLanguageCode: SystemLanguageCode.EN)),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              AccountDataBloc()..add(AccountDataEventInitialData()),
        ),
      ],
      child: BlocProvider(
        create: (BuildContext context) =>
            InternetCheckBloc()..add(InternetCheckEventCheck()),
        child: BlocProvider(
          create: (BuildContext context) => LoginBloc(
              BlocProvider.of<AccountDataBloc>(context),
              BlocProvider.of<InternetCheckBloc>(context)),
          child: BlocProvider(
            create: (BuildContext context) => CheckLoginBloc(
                BlocProvider.of<AccountDataBloc>(context),
                BlocProvider.of<LoginBloc>(context),
                BlocProvider.of<InternetCheckBloc>(context)),
            child: BlocBuilder<AppDataBloc, AppDataState>(
              builder: (context, appDataState) {
                return BlocBuilder<SystemLanguageBloc, SystemLanguageState>(
                  builder: (context, systemLanguageState) {
                    return BlocBuilder<AccountDataBloc, AccountDataState>(
                      builder: (context, accountDataState) {
                        if (appDataState is AppDataStateGettingData ||
                            accountDataState
                                is AccountDataStateInitialDataDoing) {
                          return StatePageLoading();
                        } else if (appDataState is AppDataStateError) {
                          return StatePageError();
                        } else {
                          return MyMainApp(
                            appDataStateGotData: appDataState,
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MyMainApp extends StatefulWidget {
  const MyMainApp({
    Key key,
    this.appDataStateGotData,
    //this.widget,
  }) : super(key: key);

  final AppDataStateGotData appDataStateGotData;

  @override
  _MyMainAppState createState() => _MyMainAppState();
}

class _MyMainAppState extends State<MyMainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //builder: (BuildContext context, Widget child){
      //  return MediaQuery(
      //    child: child,
      //    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      //  );
      //},
      ///localeResolutionCallback: (deviceLocale, supportedlocales) {
      ///  print('deviceLocale: $deviceLocale');
      ///  print('supportedlocales: $supportedlocales');
      ///  //BlocProvider.of<SystemLanguageBloc>(context).add(SystemLanguageEventChange(systemLanguageCode: deviceLocale.toLanguageTag()  == "en" ? SystemLanguageCode.EN : SystemLanguageCode.CN));
      ///  return deviceLocale;
      ///},
      //visualDensity: VisualDensity.adaptivePlatformDensity,
      debugShowCheckedModeBanner: true,
      title: 'PPM',
      theme: widget.appDataStateGotData.appDataModel.myThemeData.themeDataLight,
      darkTheme:
          widget.appDataStateGotData.appDataModel.myThemeData.themeDataLight,
      themeMode: ThemeMode.light,
      //onGenerateRoute: _AppRouter(appDataBloc: BlocProvider.of<AppDataBloc>(context)).onGenerateRoute,///_router.onGenerateRoute,
      //initialRoute: "Kpp01TestHomePage",
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Stack(
        children: [
          BlocBuilder<LoginBloc, LoginState>(builder: (context, loginState) {
            return BlocConsumer<CheckLoginBloc, CheckLoginState>(
              listener: (context, checkLoginState) {
                if (checkLoginState is CheckLoginStateBad) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Your account/device has changed, please login again.")));
                }
              },
              builder: (context, checkLoginState) {
                return BlocBuilder<AccountDataBloc, AccountDataState>(
                  builder: (context, accountDataState) {
                    if (loginState is LoginStateSignSuccessful &&
                        (checkLoginState is CheckLoginStateGood ||
                            checkLoginState is CheckLoginStateReadyToBad)) {
                      return AppMain();
                    } else if (accountDataState is AccountDataStateFinish &&
                        accountDataState.accountDataModel.myState == "ON" &&
                        checkLoginState is CheckLoginStateGood) {
                      BlocProvider.of<LoginBloc>(context)
                          .add(LoginEventSignInChangeToSuccessful());
                      return AppMain();
                    } else {
                      return SignInPage();
                    }
                  },
                );
              },
            );
          }),
          BlocConsumer<InternetCheckBloc, InternetCheckState>(
            listener:
                (BuildContext context, InternetCheckState internetCheckState) {
              if (internetCheckState is InternetCheckStateError) {
                BlocProvider.of<InternetCheckBloc>(context)
                    .add(InternetCheckEventToNoAction());
                print("Internet or service error");
                _globalKey.currentState.showSnackBar(
                    SnackBar(content: Text("Internet or service error")));
              }
            },
            builder:
                (BuildContext context, InternetCheckState internetCheckState) {
              if (internetCheckState is InternetCheckStateChecking) {
                return Center(
                  child: Container(
                    width: 15.0,
                    height: 15.0,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}

///class _AppRouter{
///
///  const _AppRouter({
///    @required this.appDataBloc,
///}):assert(appDataBloc != null);
///
///  final AppDataBloc appDataBloc;
///
///  Route onGenerateRoute(RouteSettings settings){
///    switch(settings.name){
///
///
///      case 'Kpp01TestHomePage':
///        return MaterialPageRoute(
///          builder: (_) => BlocProvider.value(
///            value: appDataBloc,
///            child: Kpp01TestHomePage(),
///          ),
///        );
///
///
///      case 'LearningPage':
///        return MaterialPageRoute(
///          builder: (_) => MultiBlocProvider(
///            providers: [
///              BlocProvider.value(
///                value: appDataBloc,
///              ),
///            ],
///            child: LearningPage(),
///           ),
///        );
///
///      case 'LearningPart1':
///        return MaterialPageRoute(
///          builder: (_) => MultiBlocProvider(
///            providers: [
///              BlocProvider.value(
///                value: appDataBloc,
///              ),
///            ],
///            child: LearningPartPage(),
///          ),
///        );
///
///      default:
///        return null;
///    }
///  }
///}
