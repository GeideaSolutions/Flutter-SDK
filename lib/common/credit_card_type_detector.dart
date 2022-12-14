// Supported card types
enum CreditCardType {
  mada,
  visa,
  amex,
  discover,
  mastercard,
  dinersclub,
  jcb,
  unionpay,
  maestro,
  elo,
  mir,
  hiper,
  hipercard,
  unknown,
}

/// CC prefix patterns as of March 2019
/// A [List<String>] represents a range.
/// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
const Map<CreditCardType, Set<List<String>>> cardNumPatterns = {
  CreditCardType.mada: {
    [''],
  },
  CreditCardType.visa: {
    ['4'],
  },
  CreditCardType.amex: {
    ['34'],
    ['37'],
  },
  CreditCardType.discover: {
    ['6011'],
    ['644', '649'],
    ['65'],
  },
  CreditCardType.mastercard: {
    ['51', '55'],
    ['2221', '2229'],
    ['223', '229'],
    ['23', '26'],
    ['270', '271'],
    ['2720'],
  },
  CreditCardType.dinersclub: {
    ['300', '305'],
    ['36'],
    ['38'],
    ['39'],
  },
  CreditCardType.jcb: {
    ['3528', '3589'],
    ['2131'],
    ['1800'],
  },
  CreditCardType.unionpay: {
    ['620'],
    ['624', '626'],
    ['62100', '62182'],
    ['62184', '62187'],
    ['62185', '62197'],
    ['62200', '62205'],
    ['622010', '622999'],
    ['622018'],
    ['622019', '622999'],
    ['62207', '62209'],
    ['622126', '622925'],
    ['623', '626'],
    ['6270'],
    ['6272'],
    ['6276'],
    ['627700', '627779'],
    ['627781', '627799'],
    ['6282', '6289'],
    ['6291'],
    ['6292'],
    ['810'],
    ['8110', '8131'],
    ['8132', '8151'],
    ['8152', '8163'],
    ['8164', '8171'],
  },
  CreditCardType.maestro: {
    ['493698'],
    ['500000', '506698'],
    ['506779', '508999'],
    ['56', '59'],
    ['63'],
    ['67'],
  },
  CreditCardType.elo: {
    ['401178'],
    ['401179'],
    ['438935'],
    ['457631'],
    ['457632'],
    ['431274'],
    ['451416'],
    ['457393'],
    ['504175'],
    ['506699', '506778'],
    ['509000', '509999'],
    ['627780'],
    ['636297'],
    ['636368'],
    ['650031', '650033'],
    ['650035', '650051'],
    ['650405', '650439'],
    ['650485', '650538'],
    ['650541', '650598'],
    ['650700', '650718'],
    ['650720', '650727'],
    ['650901', '650978'],
    ['651652', '651679'],
    ['655000', '655019'],
    ['655021', '655058'],
  },
  CreditCardType.mir: {
    ['2200', '2204'],
  },
  CreditCardType.hiper: {
    ['637095'],
    ['637568'],
    ['637599'],
    ['637609'],
    ['637612'],
    ['63743358'],
    ['63737423'],
  },
  CreditCardType.hipercard: {
    ['606282'],
  }
};

/// Finds non numeric characters
RegExp _nonNumeric = RegExp(r'\D+');

/// Finds whitespace in any form
RegExp _whiteSpace = RegExp(r'\s+\b|\b\s');

/// Mada
RegExp _mada = RegExp(r'^((((400861)|(409201)|(410685)|(417633)|(428331)|(42867[1-3])|(431361)|(432328)|(440533)|(440647)|(440795)|(445564)|(446404)|(446672)|(455036)|(457865)|(458456)|(462220)|(46854[0-3])|(484783)|(48931[7-9])|(490980)|(493428)|(504300)|(508160)|(521076)|(527016)|(539931)|(557606)|(558848)|(585265)|(588845)|(588846)|(588847)|(588848)|(588849)|(588850)|(588851)|(58898[2-3])|(589005)|(589206)|(604906)|(605141)|(636120)|(42281[7-9])|(9682)|(439954)|(439956)|(419593)|(48301[0-2])|(532013)|(531095)|(530906)|(455708)|(524514)|(529741)|(537767)|(535989)|(48609[4-6])|(543357)|(401757)|(446393)|(434107)|(536023)|(407197)|(407395)|(529415)|(535825)|(543085)|(549760)|(437980))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$');

/// This function determines the CC type based on the cardPatterns
CreditCardType detectCCType(String ccNumStr) {
  CreditCardType cardType = CreditCardType.unknown;
  ccNumStr = ccNumStr.replaceAll(_whiteSpace, '');;

  if (ccNumStr.length < 6) {
    return cardType;
  }

  if (ccNumStr.isEmpty) {
    return cardType;
  }

  // Check that only numerics are in the string
  if (_nonNumeric.hasMatch(ccNumStr)) {
    return cardType;
  }

  if(_mada.hasMatch(ccNumStr))
    {
      cardType = CreditCardType.mada;
      return cardType;
    }



  cardNumPatterns.forEach(
    (CreditCardType type, Set<List<String>> patterns) {
      for (List<String> patternRange in patterns) {
        // Remove any spaces
        String ccPatternStr = ccNumStr;
        int rangeLen = patternRange[0].length;
        // Trim the CC number str to match the pattern prefix length
        if (rangeLen < ccNumStr.length) {
          ccPatternStr = ccPatternStr.substring(0, rangeLen);
        }

        if (patternRange.length > 1) {
          // Convert the prefix range into numbers then make sure the
          // CC num is in the pattern range.
          // Because Strings don't have '>=' type operators
          int ccPrefixAsInt = int.parse(ccPatternStr);
          int startPatternPrefixAsInt = int.parse(patternRange[0]);
          int endPatternPrefixAsInt = int.parse(patternRange[1]);
          if (ccPrefixAsInt >= startPatternPrefixAsInt &&
              ccPrefixAsInt <= endPatternPrefixAsInt) {
            // Found a match
            cardType = type;
            break;
          }
        } else {
          // Just compare the single pattern prefix with the CC prefix
          if (ccPatternStr == patternRange[0]) {
            // Found a match
            cardType = type;
            break;
          }
        }
      }
    },
  );

  return cardType;
}
