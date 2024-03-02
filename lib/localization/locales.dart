import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale('en', LocaleData.EN),
  MapLocale('de', LocaleData.DE),
  MapLocale('hi', LocaleData.HI),
  MapLocale('mr', LocaleData.MR),
  MapLocale('gu', LocaleData.GU),
  MapLocale('te', LocaleData.TE),
];

mixin LocaleData {
  static const String title = 'title';

  static const String updates = 'updates';
  static const String features = 'features';

  static const String infoAddress = 'Address';
  static const String infoCalamity = 'Calamity';

  static const String prevAndPrecTitle = 'Preventions and Precations';
  static const String prevTitle = 'Preventions';
  static const String prevBody = 'prev body';
  static const String precTitle = 'Precations';
  static const String precBody = 'prec body';

  static const Map<String, dynamic> EN = {
    title: 'Localization',
    updates: 'Updates',
    features: 'Features',

    //Info
    infoAddress: 'Shivaji Nagar, Pune',
    infoCalamity: 'Caution: Earthquake',

    //Prev & Prec
    prevAndPrecTitle: 'Preventions and \nPrecations',
    prevTitle: 'Preventions',
    precTitle: 'Precations',
    prevBody:
        '1, Seismic Zoning: Adapt military strategies to reclassify earthquake-prone regions based on negative impact assessment.\n2. Safe Building Construction: Utilize robust construction materials and plans to make new buildings earthquake-resistant.\n3. Infrastructure Inspection: Regularly inspect buildings and structures for standard compliance to ensure their safety during earthquakes.\n4. Protection of Electrical and Water Facilities: Safeguard power and water supply infrastructure to minimize the impact of earthquakes.',
    precBody:
        '1. Take Cover Under Tables or Desks: During earthquakes, immediately take cover under a table or desk, as it can provide safety.\n2. Evacuate Buildings: In the event of buildings being in a precarious condition, evacuate to a safe location and keep yourself away from danger.\n3. Care for Children and the Elderly: Ensure the safety of children and the elderly by taking them to secure locations and providing necessary care.\n4. Stay Away from Hazardous Areas: Identify safe places and stay away from hazardous areas during an earthquake.',
  };

  static const Map<String, dynamic> DE = {
    title: 'Deutsch',
    updates: 'Aktualisierung',
    features: 'Merkmale',
    // body: 'Guten Morgen',
  };

  static const Map<String, dynamic> HI = {
    title: 'हिंदी',
    updates: 'जानकारी',
    features: 'विशेषताएँ',

    //Info
    infoAddress: 'शिवाजी नगर, पुणे',
    infoCalamity: 'सावधानी: भूकंप',

    //Prev & Prec
    prevAndPrecTitle: 'रोकथाम और सावधानियां',
    prevTitle: 'रोकथाम',
    precTitle: 'सावधानियां',
    prevBody:
        '1. भूकंप रूपरंग: भूकंप के क्षेत्रों को नकारात्मक प्रभाव के आधार पर रूपांतरित करने के लिए सामरिक रूपरंग को अनुकूलित करें।\n2. सुरक्षित भवन निर्माण: नए भवनों को भूकंप सुरक्षित बनाने के लिए मजबूत निर्माण सामग्री और योजना का उपयोग करें।\n3. विद्युतीय और जल संरचनाओं की सुरक्षा: बिजली और पानी की सप्लाई को भूकंप से प्रभावित नहीं होने के लिए सुरक्षित बनाए रखें।',
    precBody:
        '1. टेबल या डेस्क के नीचे छुपें: भूकंप के समय, तुरंत टेबल या डेस्क के नीचे छुपना सुरक्षित हो सकता है।\n2. बाहर निकलें: इमारतों की शक्तिशाली स्थिति में होने पर बाहर निकलें और खुद को खतरे से दूर रखें।\n3. बच्चों और वृद्धों की देखभाल: बच्चों और वृद्धों को सुरक्षित स्थान पर ले जाएं और उनकी देखभाल करें।\n4. खतरनाक क्षेत्रों से दूर रहें: सुरक्षित स्थानों को पहचानें और खतरनाक क्षेत्रों से दूर रहें।',
  };

  static const Map<String, dynamic> MR = {
    title: 'हिंदी',
    updates: 'अद्यतने',
    features: 'वैशिष्ट्ये',

    //Info
    infoAddress: 'शिवाजी नगर, पुणे',
    infoCalamity: 'सावधानी: भूकंप',

    //Prev & Prec
    prevAndPrecTitle: 'रोकथाम और सावधानियां',
    prevTitle: 'प्रतिबंध',
    precTitle: 'खबरदारी',
    prevBody:
        '1. भूकंप रूपरंग: भूकंप के क्षेत्रों को नकारात्मक प्रभाव के आधार पर रूपांतरित करने के लिए सामरिक रूपरंग को अनुकूलित करें।\n2. सुरक्षित भवन निर्माण: नए भवनों को भूकंप सुरक्षित बनाने के लिए मजबूत निर्माण सामग्री और योजना का उपयोग करें।\n3. विद्युतीय और जल संरचनाओं की सुरक्षा: बिजली और पानी की सप्लाई को भूकंप से प्रभावित नहीं होने के लिए सुरक्षित बनाए रखें।',
    precBody:
        '1. टेबल या डेस्क के नीचे छुपें: भूकंप के समय, तुरंत टेबल या डेस्क के नीचे छुपना सुरक्षित हो सकता है।\n2. बाहर निकलें: इमारतों की शक्तिशाली स्थिति में होने पर बाहर निकलें और खुद को खतरे से दूर रखें।\n3. बच्चों और वृद्धों की देखभाल: बच्चों और वृद्धों को सुरक्षित स्थान पर ले जाएं और उनकी देखभाल करें।\n4. खतरनाक क्षेत्रों से दूर रहें: सुरक्षित स्थानों को पहचानें और खतरनाक क्षेत्रों से दूर रहें।',
  };

  static const Map<String, dynamic> GU = {
    title: 'ગુજરાતી',
    updates: 'અપડેટ્સ',
    features: 'વિશેષતા',

    //Info
    infoAddress: 'शिवाजी नगर, पुणे',
    infoCalamity: 'सावधानी: भूकंप',

    //Prev & Prec
    prevAndPrecTitle: 'નિવારણ - સાવચેતીઓ',
    prevTitle: 'નિવારણ',
    precTitle: 'સાવચેતીઓ',
    prevBody:
        '1. भूकंप रूपरंग: भूकंप के क्षेत्रों को नकारात्मक प्रभाव के आधार पर रूपांतरित करने के लिए सामरिक रूपरंग को अनुकूलित करें।\n2. सुरक्षित भवन निर्माण: नए भवनों को भूकंप सुरक्षित बनाने के लिए मजबूत निर्माण सामग्री और योजना का उपयोग करें।\n3. विद्युतीय और जल संरचनाओं की सुरक्षा: बिजली और पानी की सप्लाई को भूकंप से प्रभावित नहीं होने के लिए सुरक्षित बनाए रखें।',
    precBody:
        '1. टेबल या डेस्क के नीचे छुपें: भूकंप के समय, तुरंत टेबल या डेस्क के नीचे छुपना सुरक्षित हो सकता है।\n2. बाहर निकलें: इमारतों की शक्तिशाली स्थिति में होने पर बाहर निकलें और खुद को खतरे से दूर रखें।\n3. बच्चों और वृद्धों की देखभाल: बच्चों और वृद्धों को सुरक्षित स्थान पर ले जाएं और उनकी देखभाल करें।\n4. खतरनाक क्षेत्रों से दूर रहें: सुरक्षित स्थानों को पहचानें और खतरनाक क्षेत्रों से दूर रहें।',
  };

  static const Map<String, dynamic> TE = {
    title: 'తెలుగు',
    updates: 'నవీకరణలు',
    features: 'లక్షణాలు',

    //Info
    infoAddress: 'शिवाजी नगर, पुणे',
    infoCalamity: 'सावधानी: भूकंप',

    //Prev & Prec
    prevAndPrecTitle: 'నివారణ - జాగ్రత్తలు',
    prevTitle: 'నివారణ',
    precTitle: 'జాగ్రత్తలు',
    prevBody:
        '1. भूकंप रूपरंग: भूकंप के क्षेत्रों को नकारात्मक प्रभाव के आधार पर रूपांतरित करने के लिए सामरिक रूपरंग को अनुकूलित करें।\n2. सुरक्षित भवन निर्माण: नए भवनों को भूकंप सुरक्षित बनाने के लिए मजबूत निर्माण सामग्री और योजना का उपयोग करें।\n3. विद्युतीय और जल संरचनाओं की सुरक्षा: बिजली और पानी की सप्लाई को भूकंप से प्रभावित नहीं होने के लिए सुरक्षित बनाए रखें।',
    precBody:
        '1. टेबल या डेस्क के नीचे छुपें: भूकंप के समय, तुरंत टेबल या डेस्क के नीचे छुपना सुरक्षित हो सकता है।\n2. बाहर निकलें: इमारतों की शक्तिशाली स्थिति में होने पर बाहर निकलें और खुद को खतरे से दूर रखें।\n3. बच्चों और वृद्धों की देखभाल: बच्चों और वृद्धों को सुरक्षित स्थान पर ले जाएं और उनकी देखभाल करें।\n4. खतरनाक क्षेत्रों से दूर रहें: सुरक्षित स्थानों को पहचानें और खतरनाक क्षेत्रों से दूर रहें।',
  };
}
