//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

class MyLocale implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "he": {
          "1": "דף כניסה",
          "2": "הגדרות",
          "3": "שפה",
          "4": "אנגלית",
          "5": "עברית",
          "6": "ערבית",
          "7": "כניסה",
          "8": "פרסם דירה",
          "9": "צאט",
          "10": "שיחות",
          "11": "יציאה",
          "12": "שם משתמש",
          "13": "סיסמה",
          "14": "שכחתי סיסמה",
          "15": "עדיין לא נרשמת? ",
          "16": "הרשמה",
          "17": "שם מלא",
          "18": "מייל",
          "19": "יש לך חשבון? ",
          "20": "חובה לרשום מספר טלפון חוקי",
          "21": "חייב לרשום שם מלא",
          "22": "תרשום מייל חוקי",
          "23": "סיסמה חייבת להיות לפחות באורך של 6 תווים",
          "24": "מחוז צפון",
          "25": "מחוז מרכז",
          "26": "מחוז חיפה",
          "27": "מחוז תל אביב-יפו",
          "28": "מחוז יורשלים",
          "29": "מחוז דרום",
          "30": "מחיר",
          "31": "חדרים ",
          "32": "שותפים: ",
          "33": "סאבלט: ",
          "34": "ישוב: ",
          "35": "רחוב: ",
          "36": "חיפוש",
          "37": "איפוס",
          "38": "קומה",
          "39": "הסבר",
          "40": "סוג",
          "41": "מחוז",
          "42": "מס רחוב",
          "43": "מרכז",
          "44": "יורשלים",
          "45": "חיפה",
          "46": "דרום",
          "47": "צפון",
          "48": "תל אביב-יפו",
          "49": "דירה",
          "50": "בית",
          "51": "מרתף",
          "52": "דירת גג",
          "53": "יחידת דיור",
          "54": "פנטהאוז",
          "55": "דירת גן",
          "56": "סטודיו",
          "57": "בית פרטי",
          "58": "סאבלט",
          "59": "דירת שותפים",
          "60": 'תמונה מגלריה',
          "61": 'צלם תמונה',
          "62": 'מועדפים',
          "63": 'אתה צריך לכנס לאפליקציה לבצע פעולה זו',
          "64": 'מייל או סיסמה לא נכונים',
          "65": 'חובה להכניס מייל',
          "66": 'תרשום מייל חוקי',
          "67": 'צריך לרשום סיסמה',
          "68": 'סיסמה חייבת להיות באורך 6 תווים לפחות',
          "69": 'הכנס סיסמה',
          "70": 'סיסמה חדשה',
          "71": 'החלף סיסמה',
          "72": 'שינוי סיסמה נשלח למייל הנבחר',
          "73": 'מספר טלפון',
          "74": 'תעודת זהות',
          "75": 'תעודת זהות חובה',
          "76": 'תעודת זהות חייבת להיות בין 9-11 תווים',
          "77": 'מספר טלפון חובה',
          "78": 'מספר טלפון חייב להיות מ 10 תווים',
          "79": 'חובה למלא שם מלא',
          "80": 'אסור לשם משתמש להכיל מספרים',
          "81": 'משתמש אחר משתמש במייל זה',
          "82": 'שינוי סיסמה',
          "83": 'מחיקת חשבון',
          "84": 'חשבון נמחק בהצלחה',
          "85": 'עדכון פרטים אישיים',
          "86": 'עדכון',
          "87": 'פרסם בית',
          "88": 'נכס בבלעדיות',
          "89": 'מיזוג',
          "90": 'סורגים',
          "91": 'דוד שמש',
          "92": 'גישה לנכים',
          "93": 'משופצת',
          "94": 'ממ"ד',
          "95": 'מחסן',
          "96": 'חיות מחמד',
          "97": 'ריהוט',
          "98": 'גמיש',
          "99": 'לטווח ארוך',
          "100": 'הוסיף תמונות',
          "101": "דירות שפרסמתי",
          "102": 'מיזוג',
          "103": 'שינוי',
          "104": 'שכונה',
          "105": 'מחיקה',
          "106": 'אין דירות',
          "107": 'פרטים אישיים השתנו בהצלחה',
          "108": 'אתה לא שינת פרטים שלך עדיין',
          "109": 'קומה',
          "110": 'פורסם ב',
          "111": 'מומלץ להסתכל',
          "112": 'דירוג',
          "113": 'הפרסומת התווספה למועדפים בהצלחה',
          "114": 'פרסומת זו נמצאת במועדפים שלך',
          "115": 'לשחזר סיסמה רשום כתובת מייל שלך כדח לקבל קישור שחזור.',
          "116": 'רשום מייל שלך והסיסמה כדי לאשר מחיקת חשבון.',
          "117": 'צפון',
          "118": 'חיפה',
          "119": 'מרכז',
          "120": 'תל אביב - יפו',
          "121": 'יורשלים',
          "122": 'דרום',
          "123": 'כניסה',
          "124": 'דירה התווספה למערכת',
          "125": 'דירה נמחקה מהמערכת',
          "126": 'מחק הודעה',
          "127": 'פרסומת נמחקה',
          "128": 'עדיין אין פרסומות',
          "129": 'הצג תוכן',
          "130": 'הודעות',
          "131": 'אין הודעות',
          "132": 'סגירה',
          "133": 'מדיניות ופרטיות',
          "134": 'מדיניות ופרטיות',
          "135": '1. הקדמה',
          "136":
              'ברוכים הבאים לאפליקציה שלנו. על ידי גישה או שימוש באפליקציה שלנו, אתה מסכים לציית לתנאים ולהגבלות אלה ולהיות מחויב להם. אם אינך מסכים לתנאים אלה, אנא אל תשתמש באפליקציה שלנו.',
          "137": '2. שימוש באפליקציה',
          "138":
              'אתה מסכים להשתמש באפליקציה רק ​​למטרות חוקיות ובאופן שאינו פוגע בזכויות, מגביל או מונע את השימוש וההנאה של מישהו אחר מהאפליקציה. התנהגות אסורה כוללת הטרדה או גרימת מצוקה או אי נוחות לכל משתמש אחר, העברת תוכן מגונה או פוגעני, או שיבוש זרימת הדיאלוג הרגילה בתוך האפליקציה.',
          "139": '3. קניין רוחני',
          "140":
              'כל התוכן הכלול באפליקציה, כגון טקסט, גרפיקה, סמלי לוגו, תמונות ותוכנה, הוא רכושו של בעל האפליקציה או ספקי התוכן שלו ומוגן על ידי חוקי זכויות יוצרים בינלאומיים. האוסף של כל התוכן באפליקציה זו הוא רכושו הבלעדי של בעל האפליקציה ומוגן על ידי חוקי זכויות יוצרים בינלאומיים.',
          "141": '4. הגבלת אחריות',
          "142":
              'האפליקציה מסופקת על בסיס "כמות שהיא" ו"כפי שהיא זמינה". בעל האפליקציה אינו מציג מצגים או אחריות מכל סוג שהוא, מפורש או משתמע, לגבי פעולת האפליקציה או המידע, התוכן, החומרים או המוצרים הכלולים באפליקציה. במידה המלאה המותרת על פי החוק החל, בעל האפליקציה מתנער מכל אחריות, מפורשת או משתמעת, לרבות, אך לא מוגבלת, אחריות משתמעת לגבי סחירות והתאמה למטרה מסוימת. בעל האפליקציה לא יישא באחריות לכל נזק מכל סוג שהוא הנובע מהשימוש באפליקציה, לרבות, אך לא רק, נזקים ישירים, עקיפים, מקריים, עונשיים ותוצאתיים.',
          "143": '5. שינויים בתנאים',
          "144":
              'אנו שומרים לעצמנו את הזכות לבצע שינויים בתנאים וההגבלות הללו בכל עת. המשך השימוש שלך באפליקציה לאחר כל שינוי ייחשב כהסכמה שלך לשינויים כאלה.',
          "145": '6. צור קשר',
          "146":
              'אם יש לך שאלות כלשהן לגבי תנאים והגבלות אלה, אנא צור איתנו קשר בכתובת aliabuabid8@gmail.com.',
          "147": 'שיחה',
          "148": 'שלח הודעה',
          "149": 'שלח קובץ',
          "150": 'בתים שלי',
          "151": 'בתהליך',
          "152": 'הושכר',
          "153": 'תשכיר בית',
          "154": 'שם ראשון',
          "155": 'שם שני',
          "156": 'שם שלישי',
          "157": 'שם רביעי',
          "158": 'שם חמישי',
          "159": 'חובה למלא שמות',
          "160": 'סיום תהליך השכרה',
          "161": 'בתים שהושכרו',
          "162": 'הצגת חוזה',
          "163": 'שליחת חוזה',
          "164": 'שינוי',
          "165": 'חוזה',
          "166": 'תשלום',
          "167": 'מספר כרטיס',
          "168": 'תוקף',
          "169": 'בעל כרטיס',
          "170": 'שלם',
          "171": 'אחרי לחיצה על כפתור הכרטיס ישמור לתשלום של 12 חודשים',
          "172": 'חתימה',
          "173": 'כרטיסים שלי',
          "174": 'הסיסמה שגויה',
          "175": 'הצג כרטיס אשראי',
          "176": 'תמיכה',
          "177": 'שאלות נפוצות (FAQ)',
          "178": 'איך לשחזר סיסמה',
          "179": 'פרטי יצירת קשר',
          "180": 'שלח כרטיס תמיכה',
          "181": 'משאבים שימושיים',
          "182": 'מדריכי משתמש',
          "183": 'טופס משוב',
          "184": 'ספק משוב',
          "185": 'קישורי רשת חברתית',
          "186": 'דיווח על שגיאה',
          "187": 'החלפת כרטיס',
          "188": 'לא נמצא אף חוזה',
          "189": 'שמירה',
          "190": 'כרטיס אשראי נשמר',
          "191": 'ההשכרה הסתיימה',
        },
        "ar": {
          "1": "الصفحة الرئيسية",
          "2": "الأعدادات",
          "3": "اللغة",
          "4": "انجليزي",
          "5": "عبري",
          "6": "عربي",
          "7": "تسجيل الدخول",
          "8": "أضف شقة للبيع",
          "9": "الدردشة",
          "10": "الأتصالات",
          "11": "تسجيل الخروج",
          "12": "أسم المستخدم",
          "13": "كلمة المرور",
          "14": "نسيت كلمة المرور",
          "15": " ليس لديك حساب؟",
          "16": "انشاء حساب",
          "17": "الأسم الكامل",
          "18": "البريد الألكتروني",
          "19": "لديك حساب؟ ",
          "20": "يجب تسجيل رقم هاتف صالح",
          "21": "يجب تسجيل أسمك الكامل",
          "22": "يجب كتابة البريد بطريقة صحيحة",
          "23": "كلمة المرور يجب أن تحتوي 6 حروف على الأقل",
          "24": "منطقة الشمال",
          "25": "منطقة المركز",
          "26": "منطقة حيفا",
          "27": "منطقة تل أبيب-يافا",
          "28": "منطقة القدس",
          "29": "منطقة الجنوب",
          "30": "السعر",
          "31": "الغرف ",
          "32": "شراكة: ",
          "33": "تأجير: ",
          "34": "البلدة: ",
          "35": "الشارع: ",
          "36": "بحث",
          "37": "حذف",
          "38": "الطابق",
          "39": "شرح",
          "40": "النوع",
          "41": "المنطقة",
          "42": "رقم الشارع",
          "43": "المركز",
          "44": "القدس",
          "45": "حيفا",
          "46": "الجنوب",
          "47": "الشمال",
          "48": "تل أبيب-يافا",
          "49": "شقة",
          "50": "منزل",
          "51": "منزل مع قبو",
          "52": "منزل مع سقف",
          "53": "وحدة سكنية",
          "54": "بينت هاوس",
          "55": "منزل مع حديقة",
          "56": "شقة فردية",
          "57": "منزل شخصي",
          "58": "تأجير",
          "59": "منزل شراكة",
          "60": 'صورة من المعرض',
          "61": 'التقط صورة',
          "62": 'المفضلة',
          "63": 'عليك تسجيل الدخول لتستطيع تشغيل هذه الميزة',
          "64": 'خطأ في البريد الالكتروني او كلمة المرور',
          "65": 'يجب ادخال البريد الالكتروني',
          "66": 'يجب ادخال بريد الكتروني صالح',
          "67": 'يجب ادخال كلمة المرور',
          "68": 'كلمة المرور يجب أن تكون من 6 حروف على الأقل',
          "69": 'أدخل كلمة المرور',
          "70": 'كلمة المرور الجديدة',
          "71": 'تغيير كلمة المرور',
          "72": 'تغيير كلمة المرور ارسل الى البريد الالكتروني المختار',
          "73": 'رقم الهاتف',
          "74": 'رقم الهوية',
          "75": 'يجب ادخال رقم الهوية',
          "76": 'رقم الهوية يجب ان يكون بين 9-11 أرقام',
          "77": 'يجب ادخال رقم الهاتف',
          "78": 'رقم الهاتف يجب ان يكون من 10 أرقام',
          "79": 'الاسم الكامل مطلوب',
          "80": 'غير مسموح باضافة ارقام للاسم الكامل',
          "81": 'هذا البريد تم استخدامه من قبل مستخدم اخر',
          "82": 'تغيير كلمة المرور',
          "83": 'حذف الحساب',
          "84": 'تم حذف الحساب بنجاح',
          "85": 'المعلومات الشخصية',
          "86": 'تغيير',
          "87": 'نشر المنزل',
          "88": 'ملكية حصرية',
          "89": 'تكييف',
          "90": 'شبابيك مغلقة',
          "91": 'سخان مياه',
          "92": 'ذوي الاحتياجات\nالخاصة',
          "93": 'مجددة',
          "94": 'ملجأ',
          "95": 'مخزن',
          "96": 'حيوانات أليفة',
          "97": 'أثاث',
          "98": 'مريح',
          "99": 'طويل الأمد',
          "100": 'أضف صور',
          "101": "المنازل التي نشرتها",
          "102": 'تكييف',
          "103": 'تغيير',
          "104": 'الحارة',
          "105": 'حذف',
          "106": 'لا يوجد شقق',
          "107": 'تم تغيير معلوماتك الشخصية بنجاح',
          "108": 'لم تقم بتغيير شيء من معلوماتك الشخصية',
          "109": 'الطابق',
          "110": 'نشر',
          "111": 'أفضل العروض',
          "112": 'تقييم',
          "113": 'تم حفظ المنشور بالمفضلة بنجاح',
          "114": 'لقد قمت بحفظ هذا المنشور',
          "115":
              'لتغيير كلمة المرور سجل بريدك الالكتروني وادخل على الموقع الذي ارسل لتغيير كلمة المرور.',
          "116":
              'لحذف حسابك الخاص سجل بريدك الالكتروني وكلمة المرور من اجل الموافقة.',
          "117": 'شمال',
          "118": 'حيفا',
          "119": 'مركز',
          "120": 'تل أبيب - يافا',
          "121": 'القدس',
          "122": 'جنوب',
          "123": 'تسجيل',
          "124": 'تم اضافة المنزل',
          "125": 'تم حذف المنزل',
          "126": 'احذف الرسالة',
          "127": 'تم حذف المنشور من المفضلة',
          "128": 'المفضلة فارغة',
          "129": 'اظهر المحتوى',
          "130": 'الرسائل',
          "131": 'لا يوجد رسائل',
          "132": 'اغلاق',
          "133": 'الأحكام والشروط',
          "134": 'الأحكام والشروط',
          "135": '1. المقدمة',
          "136":
              'مرحبا بكم في التطبيق لدينا. من خلال الوصول إلى تطبيقنا أو استخدامه، فإنك توافق على الالتزام بهذه الشروط والأحكام والالتزام بها. إذا كنت لا توافق على هذه الشروط، يرجى عدم استخدام التطبيق لدينا.',
          "137": '2. استخدام التطبيق',
          "138":
              'أنت توافق على استخدام التطبيق فقط للأغراض القانونية وبطريقة لا تنتهك حقوق أو تقيد أو تمنع أي شخص آخر من استخدام التطبيق والاستمتاع به. يتضمن السلوك المحظور مضايقة أي مستخدم آخر أو التسبب في ضيقه أو إزعاجه، أو نقل محتوى فاحش أو مسيء، أو تعطيل التدفق الطبيعي للحوار داخل التطبيق.',
          "139": '3. الملكية الفكرية',
          "140":
              'جميع المحتويات المضمنة في التطبيق، مثل النصوص والرسومات والشعارات والصور والبرامج، هي ملك لمالك التطبيق أو موردي المحتوى الخاص به ومحمية بموجب قوانين حقوق الطبع والنشر الدولية. إن تجميع كل المحتوى الموجود في هذا التطبيق هو ملكية حصرية لمالك التطبيق ومحمي بموجب قوانين حقوق الطبع والنشر الدولية.',
          "141": '4. حدود المسؤولية',
          "142":
              'يتم توفير التطبيق على أساس "كما هو" و"كما هو متاح". لا يقدم مالك التطبيق أي إقرارات أو ضمانات من أي نوع، صريحة أو ضمنية، فيما يتعلق بتشغيل التطبيق أو المعلومات أو المحتوى أو المواد أو المنتجات المضمنة في التطبيق. إلى أقصى حد يسمح به القانون المعمول به، ينكر مالك التطبيق جميع الضمانات، الصريحة أو الضمنية، بما في ذلك، على سبيل المثال لا الحصر، الضمانات الضمنية الخاصة بقابلية التسويق والملاءمة لغرض معين. لن يكون مالك التطبيق مسؤولاً عن أي أضرار من أي نوع تنشأ عن استخدام التطبيق، بما في ذلك، على سبيل المثال لا الحصر، الأضرار المباشرة وغير المباشرة والعرضية والعقابية والتبعية.',
          "143": '5. التغييرات في الشروط',
          "144":
              'نحن نحتفظ بالحق في إجراء تغييرات على هذه الشروط والأحكام في أي وقت. إن استمرارك في استخدام التطبيق بعد أي تغييرات سيعتبر بمثابة موافقتك على هذه التغييرات.',
          "145": '6. اتصل بنا',
          "146":
              'إذا كان لديك أي أسئلة حول هذه الشروط والأحكام، يرجى الاتصال بنا على aliabuabid8@gmail.com.',
          "147": 'اتصل',
          "148": 'ارسل رسالة',
          "149": 'ارسل ملف',
          "150": 'المنازل',
          "151": 'قيد التعبئة',
          "152": 'اكتملت',
          "153": 'اجر المنزل',
          "154": 'الاسم الاول',
          "155": 'الاسم الثاني',
          "156": 'الاسم الثالث',
          "157": 'الاسم الرابع',
          "158": 'الاسم الخامس',
          "159": 'يجب تعبئة الاسماء',
          "160": 'اكتمال التأجير',
          "161": 'المنازل التي\nاستأجرت',
          "162": 'أظهار العقد',
          "163": 'ارسال العقد',
          "164": 'تغيير',
          "165": 'العقد',
          "166": 'دفع',
          "167": 'رقم البطاقة',
          "168": 'تاريخ الانتهاء',
          "169": 'مالك البطاقة',
          "170": 'دفع',
          "171": 'بعد الضغط على زر الدفع سيتم حفظ البطاقة للدفع 12 شهر',
          "172": 'امضاء',
          "173": 'البطاقات الخاصة بي',
          "174": 'كلمة المرور خاطئة',
          "175": 'اظهر بطاقة الدفع',
          "176": 'الدعم الفني',
          "177": ' الاسئلة الدارجة(FAQ)',
          "178": 'كيف اغير كلمة المرور',
          "179": 'كيفية التواصل',
          "180": 'ارسل بطاقة دعم',
          "181": 'موارد مفيدة',
          "182": 'أدلة المستخدم',
          "183": 'نموذج الملاحظات',
          "184": 'تقديم الملاحظات',
          "185": 'روابط الشبكات الاجتماعية',
          "186": 'الإبلاغ عن خطأ',
          "187": 'تغيير البطاقة',
          "188": 'لا يوجد عقد',
          "189": 'حفظ',
          "190": 'تم حفظ البطاقة',
          "191": 'الاستأجار اكتمل',
        },
        "en": {
          "1": "Home Page",
          "2": "Settings",
          "3": "language",
          "4": "English",
          "5": "Hebrew",
          "6": "Arabic",
          "7": "Login",
          "8": "Add Apartment",
          "9": "Chats",
          "10": "Calls",
          "11": "Logout",
          "12": "Username",
          "13": "Password",
          "14": "Forgot password",
          "15": "Don't have account? ",
          "16": "Sign up",
          "17": "Full name",
          "18": "Email",
          "19": "Do you have account? ",
          "20": "must enter a valid phone number",
          "21": "must enter full name",
          "22": "enter a correct email",
          "23": "password must be at least 6 letters",
          "24": "North\nDistrict",
          "25": "Center\nDistrict",
          "26": "Haifa\nDistrict",
          "27": "Tel Aviv-Jaffa\nDistrict",
          "28": "Jerusalem\nDistrict",
          "29": "South\nDistrict",
          "30": "Price",
          "31": "Rooms",
          "32": "Partners: ",
          "33": "Sublet: ",
          "34": "City: ",
          "35": "Street: ",
          "36": "Search",
          "37": "Clear",
          "38": "floar",
          "39": "Description",
          "40": "Kind",
          "41": "District",
          "42": "St. number",
          "43": "Center",
          "44": "Jerusalem",
          "45": "Haifa",
          "46": "South",
          "47": "North",
          "48": "Tel Aviv-Jaffa",
          "49": "Apartment",
          "50": "House",
          "51": "Basement",
          "52": "Roof",
          "53": "Solo",
          "54": "Pint House",
          "55": "Garden House",
          "56": "Studio",
          "57": "Personal House",
          "58": "Sablet",
          "59": "partners apartment",
          "60": 'Choose from Gallery',
          "61": 'Take a Photo',
          "62": 'Favorites',
          "63": 'You must log in to perform this action.',
          "64": 'Incorrect Email or Password',
          "65": 'Email is required',
          "66": 'Enter a valid email',
          "67": 'Password is required',
          "68": 'Password must be at least 6 characters long',
          "69": 'Enter password',
          "70": 'New password',
          "71": 'Change password',
          "72": 'Reseting password sent to the choosen email',
          "73": 'Phone number',
          "74": 'Id number',
          "75": 'Id number is required',
          "76": 'Id number must be between 9-11',
          "77": 'Phone number is required',
          "78": 'Phone number must be 10 numbers',
          "79": 'Full name is required',
          "80": 'Full name mustnt have a numbers',
          "81": 'The account already exists for that email.',
          "82": 'Reset Password',
          "83": 'Delete User',
          "84": 'User account deleted successfully.',
          "85": 'Edit information',
          "86": 'Update',
          "87": 'Share house',
          "88": 'Exclusive\nproperty',
          "89": 'Air\ncondi\ntion',
          "90": 'Bars',
          "91": 'Heater',
          "92": 'Access for\ndisabled',
          "93": 'Renovated',
          "94": 'Shelter',
          "95": 'Storage',
          "96": 'Pets',
          "97": 'Furniture',
          "98": 'flexible',
          "99": 'Long term',
          "100": 'Add photos',
          "101": "House I shared",
          "102": 'Air\ncond',
          "103": 'Edit',
          "104": 'neighborhood',
          "105": 'Delete',
          "106": 'There is no apartments',
          "107": 'your information have been changed successfuly',
          "108": 'You didnt fill anything to change',
          "109": 'Floar',
          "110": 'Posting date',
          "111": 'Best Offers',
          "112": 'Rating',
          "113": 'The post added to your favourites successfuly',
          "114": 'The post was found in your favourites',
          "115":
              'To change your password enter your email and go to check the changing message.',
          "116":
              'To delete your user enter your email and password to confirm.',
          "117": 'North',
          "118": 'Haifa',
          "119": 'Center',
          "120": 'Tel Aviv-Jaffa',
          "121": 'Jerusalem',
          "122": 'South',
          "123": 'login',
          "124": 'Apartment added successfuly',
          "125": 'Apartment deleted successfuly',
          "126": 'Delete notification',
          "127": 'Post deleted',
          "128": 'No favorites yet',
          "129": 'Show Content',
          "130": 'Notifications',
          "131": 'No messages',
          "132": 'Cancle',
          "133": 'Terms',
          "134": 'Terms And Conditions',
          "135": '1. Introduction',
          "136":
              'Welcome to our app. By accessing or using our app, you agree to comply with and be bound by these terms and conditions. If you do not agree to these terms, please do not use our app.',
          "137": '2. Use of the App',
          "138":
              'You agree to use the app only for lawful purposes and in a way that does not infringe the rights of, restrict, or inhibit anyone else\'s use and enjoyment of the app. Prohibited behavior includes harassing or causing distress or inconvenience to any other user, transmitting obscene or offensive content, or disrupting the normal flow of dialogue within the app.',
          "139": '3. Intellectual Property',
          "140":
              'All content included on the app, such as text, graphics, logos, images, and software, is the property of the app owner or its content suppliers and protected by international copyright laws. The compilation of all content on this app is the exclusive property of the app owner and protected by international copyright laws.',
          "141": '4. Limitation of Liability',
          "142":
              'The app is provided on an "as is" and "as available" basis. The app owner makes no representations or warranties of any kind, express or implied, as to the operation of the app or the information, content, materials, or products included on the app. To the full extent permissible by applicable law, the app owner disclaims all warranties, express or implied, including, but not limited to, implied warranties of merchantability and fitness for a particular purpose. The app owner will not be liable for any damages of any kind arising from the use of the app, including, but not limited to, direct, indirect, incidental, punitive, and consequential damages.',
          "143": '5. Changes to the Terms',
          "144":
              'We reserve the right to make changes to these terms and conditions at any time. Your continued use of the app following any changes will be deemed to be your acceptance of such changes.',
          "145": '6. Contact Us',
          "146":
              'If you have any questions about these terms and conditions, please contact us at aliabuabid8@gmail.com.',
          "147": 'Call',
          "148": 'Send message',
          "149": 'Send File',
          "150": 'My Houses',
          "151": 'In Progress',
          "152": 'Completed',
          "153": 'Make Rent',
          "154": 'First name',
          "155": 'Second name',
          "156": 'Third name',
          "157": 'Fourth name',
          "158": 'Fifth name',
          "159": 'Please fill in all the required fields.',
          "160": 'Rental Completed',
          "161": 'Rented houses',
          "162": 'Show contract',
          "163": 'Send contract',
          "164": 'Change',
          "165": 'Contract',
          "166": 'Payment',
          "167": 'Credit Number',
          "168": 'Expired Date',
          "169": 'Card Holder',
          "170": 'Validate',
          "171":
              'after validating credit card it will make a subscription for 12 months',
          "172": 'Signature',
          "173": 'My Cards',
          "174": 'Incorrect Password',
          "175": 'Show Payments',
          "176": 'Support',
          "177": 'Frequently Asked Questions (FAQ)',
          "178": 'How do I reset my password?',
          "179": 'How to contact support team',
          "180": 'Send support card',
          "181": 'useful resources',
          "182": 'User manuals',
          "183": 'feedback form',
          "184": 'provide feedback',
          "185": 'Social Network Links',
          "186": 'send report on problem',
          "187": 'Change card',
          "188": 'There is no contract',
          "189": 'Save',
          "190": 'Credit card added successfuly',
          "191": 'Rental completed',
        }
      };
}
