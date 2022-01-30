import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp2_gestion_temps/widget.dart';

class ModeleMinuteur {
  String temps;
  double pourcentage = 1.0;

  ModeleMinuteur(this.temps, this.pourcentage);
}

class Minuteur {
  double _rayon = 1;
  bool _estActif = false;
  Duration _temps = Duration();
  Duration _tempsTotal = Duration();
  int tempsTravail = DEFAULT_TPS_TRAVAIL;
  int tempsPauseCourte = DEFAULT_TPS_PAUSE_COURTE;
  int tempsPauseLongue = DEFAULT_TPS_PAUSE_LONGUE;

  Stream<ModeleMinuteur> stream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String temps;
      if (this._estActif) {
        _temps = _temps - Duration(seconds: 1);
        _rayon = _temps.inSeconds / _tempsTotal.inSeconds;
        if (_temps.inSeconds <= 0) {
          _estActif = false;
        }
      }
      temps = retournerTemps(_temps);
      return ModeleMinuteur(temps, _rayon);
    });
  }

  void demarrerMaxiPause() async {
    await lireParametres();
    _demarrerTemps(this.tempsPauseLongue);
  }

  void demarrerMiniPause() async {
    await lireParametres();
    _demarrerTemps(this.tempsPauseCourte);
  }

  void demarrerTravail() async {
    await lireParametres();
    _demarrerTemps(this.tempsTravail);
  }

  void _demarrerTemps(int mins) {
    _rayon = 1;
    _temps = Duration(minutes: mins, seconds: 0);
    _tempsTotal = _temps;
  }

  void arretMinuteur() {
    _estActif = false;
  }

  void relancerMinuteur() {
    if (_temps.inSeconds > 0) {
      _estActif = true;
    }
  }

  lireParametres() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? tempsTravail_BD = preferences.getInt(CLE_TEMPS_TRAVAIL);
    if (tempsTravail_BD == null) {
      await preferences.setInt(CLE_TEMPS_TRAVAIL, DEFAULT_TPS_TRAVAIL);
      tempsTravail_BD = preferences.getInt(CLE_TEMPS_TRAVAIL);
    }
    int? tempsPauseCourte_BD = preferences.getInt(CLE_PAUSE_COURTE);
    if (tempsPauseCourte_BD == null) {
      await preferences.setInt(CLE_PAUSE_COURTE, DEFAULT_TPS_PAUSE_COURTE);
      tempsPauseCourte_BD = preferences.getInt(CLE_PAUSE_COURTE);
    }
    int? tempsPauseLongue_BD = preferences.getInt(CLE_PAUSE_LONGUE);
    if (tempsPauseLongue_BD == null) {
      await preferences.setInt(CLE_PAUSE_LONGUE, DEFAULT_TPS_PAUSE_LONGUE);
      tempsPauseLongue_BD = preferences.getInt(CLE_PAUSE_LONGUE);
    }

    this.tempsTravail = tempsTravail_BD!;
    this.tempsPauseCourte = tempsPauseCourte_BD!;
    this.tempsPauseLongue = tempsPauseLongue_BD!;
  }
}

String retournerTemps(Duration t) {
  String minutes = (t.inMinutes < 10)
      ? '0' + t.inMinutes.toString()
      : t.inMinutes.toString();
  int numSecondes = t.inSeconds - (t.inMinutes * 60);
  String secondes = (numSecondes < 10)
      ? '0' + numSecondes.toString()
      : numSecondes.toString();
  String tempsFormate = minutes + ':' + secondes;
  return tempsFormate;
}
