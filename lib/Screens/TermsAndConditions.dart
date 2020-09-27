import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Conditions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "HarytHyzmat onlaýn harytlary we hyzmatlar bazaryna hoş geldiňiz!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  "HarytHyzmat programmalaryny we web sahypalaryny ulanmazdan öňürti, şu aşakdaky ähli ulanyş düzgünnamalaryny okamap tanyşmagyňyzy haýyş edýäris. HarytHyzmat programmalaryny we web sahypalaryny ulanmagyňyz bu düzgünnama bilen tanyşyp, razylaşandygyňyzy aňladýar.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  "Goşmaça, bu düzgünnama (“HarytHyzmat”) onlaýn hyzmadynyň häzirki wagtda hödürlenýän, we geljekde hödürlenjek hyzmatlarynyň ulanyş düzgünnamalaryny belleýär, eger-de geljekde hödürlenjek düzgünnamada başgaça görkezilmedik bolsa, onda şu düzgünnama ulanylýar.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Düzgünnama",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  "⚫     Hyzmatlary ulanyşyň umumy düzgünleri",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7, left: 20),
                child: Text(
                  "⚫     Bilgi we düzgün bozulmalar barada",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7, left: 20),
                child: Text(
                  "⚫     Bilgi we HarytHyzmat talabyna laýyk bolmadyk maglumaty habar bermek barada",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Hyzmatlary ulanyşyň umumy düzgünleri",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15),
                child: Text(
                  "1. Siziň hasabyňyz barada",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  "Eger-de siz şul programmany ýa-da web sahypany ulanýan bolsaňyz onda, siz öz hasabyňyzyň açar sözlerini we ulanyjynyň bilgisi bolmazdan hasaba girmeginiň öňüni almagy we ähli maglumatlaryň gizlinlikdedigini üpjün etmeli. Siziň sahybaňyzdan ýa-da açar sözüňiziň ulanyşy netijesinde gelip çykan ýa-da çykyp biläýjek ýagdaýlaryň we meseleriň ählisine jogapkärçiligi çekýändigiňize razylyk berýärsiňiz. Siz açar sözüňiziň, hasaba giriş edip bilinjek ähli maglumatlary gizlinlikde saklap, hasabyň eýesinden başga biriniň eýe bolmagyna/girmegine ýol bermezligi we meňzeş ýagdaýlaryň emele gelmegi halatynda, gaýra-goýulmasyz bize, ýagny  “harythyzmat@gmail.com” elektron poçtamyza habar berjegiňize güwä geçýärsiňiz. Bize berýän maglumatyňyzyň dogry we düzüw bolmagayny we üýtgän ýagdaýynda bize habar bermelidini duýdurýarys. Siz öz maglumatyňyzy “meniň hasabym” bölümi arkaly görüp, dolandyryp, we biziň hödürleýän ukybymyza çenli üýtgedip bilersiňiz, we öz alyjy hasabyňyzy diňe satyn alyjy we sarp ediji hökmünde ulanjakdygyňyza we biznes maksatlarynda ulanmajakdygyňyza doly düşünüp, güwä geçýärsiňiz. “HazytHyzmat” sahypalary ulanyşyndan, olara girişi, programmalara we web sahypalara girişi çäklendirmegine, sahypalary durdurmaga, öçürmäge, maglumatlary harytdyr hyzmatlary we başga-da islendik ýüklenen, goýulan, girizilen maglumatlary özünde size habar bermezden saklamaga, üýtgetmäge, öçürmäge haklydyr.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15),
                child: Text(
                  "2. Gizlinlik",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  "Siz tarapyndan berilen maglumatlaryň gizli we başga üçünji partiýa adamlaryna paýlanylmazlygyny  HarytHyzmat üpjün edýär, eger-de käbir maglumatlar başga biri bilen baýlaşylan diýip çak etseňiz, bu hyzmatlary ulanmagyňyzy bes edip bilersiňiz.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15),
                child: Text(
                  "3. Elektron platformada gatnaşyk",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  "Siz razy, we düşünip kabul edýärsiňiz bu programmalaryň onlaýn söwda platformasydygyny, we ähli edilýän söwda we başga aragatnaşyklar HarytHyzmat programmasy tarapyndan dolandyrylmaýar, we ähli tranzaksiýalar satyn alyjy we satyjynyň üstündäki borçlarydyr. HarytHyzmat diňe sowda meýdançasyny hödürläp, onuň borçlary çäklidir.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Bilgi we düzgün bozulmalar barada",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  "Eger-de satyjy ýa-da alyjy tarapyndan düzgün ýa-da kanun bozulmalar ýüze çykan ýagdaýynda bize email arkaly habar etmelisiňiz, biz hem öz gezegimizde meseläni gaýra goýmazdan çözmäge çemeleşeris.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  "Satyjylar we hyzmatlary hödürleýän müşderilerimiz öz işini kanuna laýyk ýerine ýetirmelidir, ýagny, işini degişli edaralarda bellige alnan we ähli salgyt borçlaryna özbaşdak jogapkärçilikli garamagyny size bildirýäris.  HarytHyzmat şu ýokarda bellenen işlere hiç hili gatnaşygy we jogapkärçiligi ýokdur.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Bilgi we HarytHyzmat talabyna laýyk bolmadyk maglumaty habar bermek barada",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  "Eger-de siz öz ýa-da haklaryňyz kemsidilendigine göz ýetiren bolsaňyz onda harythyzmat@gmail.com email adresine şu aşakdaky maglumatlar bilen we delilleri ugratmagyňyzy size bilgilendirýäris.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Text(
                        "Ugradyjy :",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "ugradyjynyň email adres",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Text(
                        "Kabul ediji :",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "harythyzmat@gmail.com",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Text(
                        "Tema :",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "Arza/Şikaýat/düzgün bozulma",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Text(
                        "Hat :",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "Arzaňyz, Şikaýatyňyz, ýa-da duçar bolan düzgün bozulmalary barada giňişleýin ýazyp, degişli delilleri birikdirmeli",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
