import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/appDataBloc/bloc.dart';
import 'package:kpp01/bloc/checkLoginBloc/bloc.dart';
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
  Bloc.observer = SimpleBlocObserver();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {

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
        create: (BuildContext context) => LoginBloc(BlocProvider.of<AccountDataBloc>(context)),
        child: BlocProvider(
          create: (BuildContext context) => CheckLoginBloc(BlocProvider.of<AccountDataBloc>(context),BlocProvider.of<LoginBloc>(context)),
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


     /// BlocBuilder<AppDataBloc,AppDataState>(
     ///   builder: (context,appDataState){
     ///     return BlocBuilder<AccountDataBloc,AccountDataState>(
     ///       builder: (context,accountDataState){
     ///         return BlocProvider(
     ///           create: (BuildContext context) => LoginBloc(BlocProvider.of<AccountDataBloc>(context)),
     ///           child: BlocBuilder<LoginBloc,LoginState>(
     ///             builder: (context,loginState){
     ///               return BlocProvider(
     ///                 create: (BuildContext context) => CheckLoginBloc(BlocProvider.of<AccountDataBloc>(context),BlocProvider.of<LoginBloc>(context)),
     ///                 child: BlocBuilder<CheckLoginBloc,CheckLoginState>(
     ///                   builder: (context, checkLoginState){
     ///                     if(appDataState is AppDataStateGettingData || accountDataState is AccountDataStateInitialDataDoing){
     ///                       return StatePageLoading();
///
     ///                     } else if(appDataState is AppDataStateError){
     ///                       return StatePageError();
///
     ///                     } else if(loginState is LoginStateSignSuccessful && appDataState is AppDataStateGotData && (checkLoginState is CheckLoginStateGood || checkLoginState is CheckLoginStateReadyToBad)){
     ///                       return  MyMainApp(appDataStateGotData: appDataState, widget: AppMain(),);
///
     ///                     } else if(accountDataState is AccountDataStateFinish && appDataState is AppDataStateGotData && accountDataState.accountDataModel.loginState == "ON" && (checkLoginState is CheckLoginStateGood || checkLoginState is CheckLoginStateReadyToBad)){
     ///                       BlocProvider.of<LoginBloc>(context).add(LoginEventSignInChangeToSuccessful());
     ///                       return MyMainApp(appDataStateGotData: appDataState, widget: AppMain(),);
///
     ///                     } else {
     ///                       return MyMainApp(appDataStateGotData: appDataState, widget: SignInPage(),);
///
     ///                     }
///
     ///                   },
     ///                 ),
     ///               );
     ///             },
     ///           ),
     ///         );
     ///       },
     ///     );
     ///   },
     /// ),
    );
  }
}

class MyMainApp extends StatelessWidget{

  const MyMainApp({
    Key key,
    this.appDataStateGotData,
    //this.widget,
}):super(key:key);

  final AppDataStateGotData appDataStateGotData;
  //final Widget widget;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      builder: (BuildContext context, Widget child){
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      debugShowCheckedModeBanner: true,
      title: 'PKK01',
      theme: appDataStateGotData.appDataModel.myThemeData.themeDataLight,
      darkTheme: appDataStateGotData.appDataModel.myThemeData.themeDataDark,
      themeMode: ThemeMode.light,
      //onGenerateRoute: _AppRouter(appDataBloc: BlocProvider.of<AppDataBloc>(context)).onGenerateRoute,///_router.onGenerateRoute,
      //initialRoute: "Kpp01TestHomePage",
      home: Scaffold(
        body: BlocBuilder<LoginBloc,LoginState>(
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
        ),
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
