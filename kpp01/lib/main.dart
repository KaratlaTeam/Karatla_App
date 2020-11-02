import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:kpp01/bloc/appDataBloc/bloc.dart';
import 'package:kpp01/bloc/checkLoginBloc/bloc.dart';
import 'package:kpp01/bloc/internetCheckBloc/bloc.dart';
import 'package:kpp01/bloc/loginBloc/bloc.dart';
import 'package:kpp01/bloc/loginBloc/loginBloc.dart';
import 'package:kpp01/bloc/accountDataBloc/bloc.dart';
import 'package:kpp01/bloc/simpleBlocDelegate.dart';
import 'package:flutter/material.dart';
import 'package:kpp01/dataModel/appDataModel.dart';
import 'package:kpp01/statePage.dart';
import 'package:kpp01/ui/appMain.dart';
import 'package:kpp01/ui/login/signIn.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
    )
  );
  Bloc.observer = SimpleBlocObserver();
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      FlutterDisplayMode.current.then((displayMode) {
        FlutterDisplayMode.setMode(displayMode);
        FlutterDisplayMode.setDeviceDefault();
        print(displayMode);
      });

    }

  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppDataBloc(appDataModel: AppDataModel())..add(AppDataEventGetData(0)),
        ),
        BlocProvider(
          create: (BuildContext context) => AccountDataBloc()..add(AccountDataEventInitialData()),
        ),
      ],
      child: BlocProvider(
        create: (BuildContext context) => InternetCheckBloc(context: null,)..add(InternetCheckEventCheck()),
        child: BlocProvider(
          create: (BuildContext context) => LoginBloc(BlocProvider.of<AccountDataBloc>(context),BlocProvider.of<InternetCheckBloc>(context)),
          child: BlocProvider(
            create: (BuildContext context) => CheckLoginBloc(BlocProvider.of<AccountDataBloc>(context),BlocProvider.of<LoginBloc>(context),BlocProvider.of<InternetCheckBloc>(context)),
            child: BlocBuilder<AppDataBloc,AppDataState>(
              builder: (context,appDataState){
                return BlocBuilder<AccountDataBloc,AccountDataState>(
                  builder: (context,accountDataState){
                    if(appDataState is AppDataStateGettingData || accountDataState is AccountDataStateInitialDataDoing){
                      return StatePageLoading();

                    } else if(appDataState is AppDataStateError){
                      return StatePageError();

                    }else {
                      return MyMainApp(appDataStateGotData: appDataState,);

                    }
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
  }) :super(key: key);

  final AppDataStateGotData appDataStateGotData;

  @override
  _MyMainAppState createState() => _MyMainAppState();
}

class _MyMainAppState extends State<MyMainApp>{
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      //builder: (BuildContext context, Widget child){
      //  return MediaQuery(
      //    child: child,
      //    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      //  );
      //},
      debugShowCheckedModeBanner: true,
      title: 'PPM',
      theme: widget.appDataStateGotData.appDataModel.myThemeData.themeDataLight,
      darkTheme: widget.appDataStateGotData.appDataModel.myThemeData.themeDataLight,
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

class _MyHomeState extends State<MyHome>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<InternetCheckBloc, InternetCheckState>(
            listener: (BuildContext context, InternetCheckState internetCheckState){
              if((internetCheckState is InternetCheckStateBad || internetCheckState is InternetCheckStateError) && internetCheckState.context != null){
                BlocProvider.of<InternetCheckBloc>(context).add(InternetCheckEventToNoAction());
                Scaffold.of(internetCheckState.context).showSnackBar(SnackBar(content: Text("Internet or service error"))) ;

              }

            },
            builder: (BuildContext context, InternetCheckState internetCheckState){
              return BlocBuilder<LoginBloc,LoginState>(
                  builder: (context,loginState){
                    return BlocConsumer<CheckLoginBloc,CheckLoginState>(
                      listener: (context,checkLoginState){
                        if(checkLoginState is CheckLoginStateBad){
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your account/device has changed, please login again.")));

                        }
                      },
                      builder: (context, checkLoginState){
                        return BlocBuilder<AccountDataBloc,AccountDataState>(
                          builder: (context,accountDataState){
                            if(loginState is LoginStateSignSuccessful &&  (checkLoginState is CheckLoginStateGood || checkLoginState is CheckLoginStateReadyToBad)){
                              return  AppMain();

                            } else if(accountDataState is AccountDataStateFinish && accountDataState.accountDataModel.myState == "ON" && checkLoginState is CheckLoginStateGood ){
                              BlocProvider.of<LoginBloc>(context).add(LoginEventSignInChangeToSuccessful());
                              return AppMain();

                            } else {
                              return SignInPage();

                            }
                          },
                        );
                      },
                    );
                  }
              );
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
