#!/usr/bin/env ruby

require 'test_helper'
require 'more_math'

class SequenceTest < Test::Unit::TestCase
  include MoreMath

  def setup
    @flat = Sequence.new([0.3] * 100)
    @flat_fuzzy = Sequence.new(
      [ 0.291296142070089, 0.398027886480809, 0.23101231921608,
        0.340627534773153, 0.254242992113383, 0.205044980114447,
        0.278185292370019, 0.291682510899134, 0.261657208149687,
        0.259844137242866, 0.378499162508619, 0.229358104972725,
        0.386112073235523, 0.235255070067096, 0.296721262492287,
        0.314698077842112, 0.363272733105109, 0.252507159666997,
        0.24662025484673, 0.267331187480918, 0.250067060724856,
        0.284270210340375, 0.262626100532033, 0.352433737639362,
        0.26289285183689, 0.320853587421585, 0.311156494750873,
        0.334225510831559, 0.356205648289854, 0.390488123286748,
        0.232295923957093, 0.306018392326888, 0.226951061989688,
        0.214593004467917, 0.28960026747272, 0.265265575971784,
        0.281799797229565, 0.337363136532618, 0.342475071004423,
        0.284553882868128, 0.389206786931739, 0.351602477407745,
        0.387218788482334, 0.251003385993573, 0.257866093151574,
        0.328824195781741, 0.328242240833557, 0.318885903421821,
        0.319274078029297, 0.29658003664557, 0.24884905382522,
        0.301770636812583, 0.248911378817175, 0.275471776328434,
        0.220091513752346, 0.283076025940448, 0.388218608044549,
        0.283229339831472, 0.224570945957831, 0.362485839646397,
        0.221550677368212, 0.269482540591461, 0.339070334243095,
        0.325182999080969, 0.308728933369353, 0.3863941656383,
        0.202792339314435, 0.362856265274183, 0.265505144702292,
        0.353077334823915, 0.324128317440701, 0.296975637938554,
        0.331591291884613, 0.205993447724166, 0.214480100701257,
        0.344614724259284, 0.370516595329498, 0.207412716360969,
        0.314721036012706, 0.228984115281106, 0.259032440399333,
        0.326352618555389, 0.353756258146666, 0.230771059239658,
        0.250581960820831, 0.21462520718052, 0.241570172219703,
        0.296495456059297, 0.336874993277199, 0.399203721142938,
        0.330151086176299, 0.327699314698143, 0.235627029696985,
        0.325564466304218, 0.398295977228244, 0.33192554316584,
        0.22526704197204, 0.342117813790757, 0.32678523559579,
        0.214938036987578 ]
    )
    @flat_fuzzy2 = Sequence.new(
      [ 0.234651800685522, 0.291677132057536, 0.381325747665659,
        0.37072453863211, 0.368865699927557, 0.35787506718781,
        0.350720373167135, 0.258635475849321, 0.31707597552194,
        0.307893709010183, 0.237849819950067, 0.315881610046543,
        0.201585641064648, 0.344368312712124, 0.34501166666737,
        0.294042914293632, 0.211771331394304, 0.363815509779845,
        0.33673412152282, 0.37498088769697, 0.201244093764913,
        0.236387765961558, 0.296850838293593, 0.223829530755105,
        0.213694650150962, 0.227416795706971, 0.200625724917622,
        0.31227957802719, 0.385983037604518, 0.287242927867868,
        0.258470258047964, 0.344169516126964, 0.26994416010751,
        0.249768846393261, 0.354426097251265, 0.34021066927398,
        0.307077285175548, 0.3497224779728, 0.254650791783532,
        0.285180048375893, 0.201603698883297, 0.314417350151038,
        0.320909639401826, 0.287679809618447, 0.328814685203504,
        0.370476190838299, 0.291359505243309, 0.273781936455096,
        0.325113918862285, 0.367110740063297, 0.247073598694453,
        0.350942986897521, 0.232261700593331, 0.236635735267053,
        0.240796903369692, 0.323428956239516, 0.324614910738737,
        0.237871567371432, 0.310816928958706, 0.264609945655404,
        0.236819188672949, 0.28398352994042, 0.366840181124702,
        0.339882426068036, 0.397478482750453, 0.379375601208701,
        0.281206116730092, 0.203947998858132, 0.231558650797902,
        0.380785793096893, 0.334270739370193, 0.266229655641688,
        0.315762224650585, 0.243378114262551, 0.294001949668671,
        0.247508966656796, 0.382845661950797, 0.369479413879656,
        0.241683415140724, 0.218541361179393, 0.319914186441019,
        0.310250120051708, 0.234697684147101, 0.34734046492662,
        0.218217334366937, 0.312537298293074, 0.374319776312122,
        0.392178633368011, 0.314428694398314, 0.386204177791726,
        0.359061970124816, 0.362334074442194, 0.229293408035385,
        0.313763536361359, 0.239344793134688, 0.265237324138875,
        0.329259743982286, 0.351767216150251, 0.211193779699827,
        0.258235773260784 ]
    )
    @flat_higher = Sequence.new(
      [ 0.417776755544947, 0.326476805772892, 0.332887733006402,
        0.410565271773857, 0.426114386030809, 0.435935520406595,
        0.339995159533461, 0.364761157546518, 0.378397233333935,
        0.35210733002035, 0.330688506187733, 0.492648864412129,
        0.33833199089868, 0.42789271416588, 0.302423735510181,
        0.305407403523733, 0.408725319360953, 0.444623946541953,
        0.494162827022184, 0.386239353430498, 0.306437290600178,
        0.376703331326491, 0.419906847790677, 0.301955977987602,
        0.487468198801442, 0.312290516021979, 0.495906290662686,
        0.303379939018008, 0.460384318463054, 0.473534870478338,
        0.333912270251847, 0.460143618655486, 0.419257177279749,
        0.355072829732943, 0.453419475031392, 0.468523177257953,
        0.405173514106214, 0.490981451264441, 0.333761262319564,
        0.405754543238307, 0.495673694657207, 0.302783349166472,
        0.432418922874345, 0.329915804259514, 0.356588738342812,
        0.354349707229742, 0.452693480248568, 0.474877692732008,
        0.405383243600942, 0.402915847080871, 0.492915699075631,
        0.462094206093751, 0.339883346924172, 0.451846443788079,
        0.464163288957183, 0.405878012725365, 0.467568948869427,
        0.419585038305752, 0.422900365624952, 0.494116259378179,
        0.300073213028546, 0.474018244228735, 0.38822872923958,
        0.441707083196939, 0.406814346112675, 0.403958151779294,
        0.307247538830431, 0.409650643221185, 0.493148685003474,
        0.36058138779566, 0.36321317486353, 0.393068747347969,
        0.468879326612198, 0.425234138346863, 0.421949132207673,
        0.306005645410334, 0.439055703332639, 0.317183300984821,
        0.470848293063698, 0.440820107004846, 0.438285035336276,
        0.434787376714648, 0.453596753001295, 0.399893734859051,
        0.458116608707833, 0.330973155542121, 0.31666421784907,
        0.467682075506155, 0.452806591013364, 0.379423936292945,
        0.357212688143182, 0.385848611013958, 0.349586136874291,
        0.46683976269393, 0.484776275752459, 0.30829081820033,
        0.41637633029041, 0.350847171677106, 0.416615749876575,
        0.382674729559805 ]
    )
    @half = Sequence.new(Array.new(100) { |i| 0.5 * i })
    @rand = Sequence.new(rand = [
      97, 26, 9, 78, 15, 86, 82, 24, 57, 67, 46, 86, 28,
      50, 71, 92, 18, 19, 16, 70, 80, 45, 26, 4, 16, 55, 15,
      94, 12, 73, 89, 97, 10, 2, 77, 35, 76, 46, 48, 31, 39,
      52, 82, 53, 88, 90, 1, 39, 77, 71, 37, 37, 50, 19, 60,
      48, 0, 13, 62, 34, 90, 28, 42, 9, 63, 82, 43, 98, 86,
      3, 94, 5, 79, 11, 16, 0, 90, 81, 42, 64, 76, 92, 25,
      3, 90, 51, 15, 0, 74, 98, 93, 90, 14, 81, 85, 28, 30,
      73, 32, 88])
    @rand_up = Sequence.new(Array.new(rand.size) { |i| rand[i] * (1 - 4.0 / (i + 1)) })
    @rand_down = Sequence.new(Array.new(rand.size) { |i| rand[i] * (1 + 4.0 / (i + 1)) })
    @rasi = Sequence.new(
      [ 0.0, 11.7813239550446, 23.8742291678261, 0.368124552684678,
      20.233654312272, 7.64120827980215, 61.609239533582, 69.346191849821,
      66.7019061146592, 26.2399845215146, 2.85316954888546, 29.4686175218607,
      15.9684276548523, 15.9684276548523, 36.3446282769615, 66.5739561406607,
      85.9585699842718, 75.9895132951814, 9.24615891330947, 7.53001816521557,
      22.335839587114, 32.2774961648149, 31.2905869781976, 15.1700831170561,
      6.1413284446509, -2.95898288510399e-14, -4.63732964187926,
      -2.2382089844837, -2.20874731610807, -0.0, -20.5724838302366,
      -60.2401453217246, -39.2961753815653, -59.9472827106431,
      -47.051006728233, -4.75528258147577, -20.6280322653025, -43.913176050844,
      -78.8441115458335, -30.4509047725893, -38.0422606518061,
      -77.8151265120777, -4.22163962751007, -32.3615561965831,
      -42.4419205675787, -40.5571824081806, -6.2627977633223,
      -5.52186829027017, -6.96331684061593, -10.4026583858372,
      3.8595428936139e-15, 9.0239928166299, 12.9318741325725, 34.9718325050444,
      46.7301063878664, 49.3739611925678, 58.1865040039386, 30.8205297110316,
      36.3061007965867, 29.8592927313786, 88.4482560154493, 54.0257987900779,
      16.9664543832806, 92.8164857438293, 62.8663840466361, 78.9376908524978,
      41.6220444134369, 78.5224970716874, 35.4436091676863, 66.4010692750828,
      14.6946313073118, 19.2701469640686, 31.6587115308823, 15.1700831170561,
      1.25333233564304, 1.83690953073357e-15, -4.76266287544359,
      -17.6569819887047, -12.1481102385944, -39.5038012763407,
      -20.5724838302365, -28.0664313430763, -20.8038575549463,
      -10.1319351060242, -10.8579246295922, -33.2869780703304,
      -77.6006928075664, -21.956588025422, -44.9112027792722,
      -56.9726605422639, -19.0211303259031, -80.5296076694757,
      -15.1979026590363, -51.6243872659778, -45.1801089912934,
      -54.6640284631999, -17.3431322676617, -21.719348608396, -11.937114583913,
      -3.38399730623621 ]
    )
    @rasi_mean = Sequence.new([ 3.48 ] * 100)
    @book = Sequence.new(
      [ 47, 64, 23, 71, 38, 64, 55, 41, 59, 48, 71, 35, 57, 40, 58,
        44, 89, 55, 37, 74, 51, 57, 50, 60, 45, 57, 50, 45, 25, 59,
        50, 71, 56, 74, 50, 58, 45, 54, 36, 54, 48, 55, 45, 57, 50,
        62, 44, 64, 43, 52, 38, 59, 55, 41, 53, 49, 34, 35, 54, 45,
        68, 38, 50, 60, 39, 59, 40, 57, 54, 23 ]
    )
  end

  def test_flat
    assert_equal 100, @flat.size
    assert_in_delta 0.3, @flat.mean, 1E-8
    assert_in_delta 0.3, @flat.geometric_mean, 1E-8
    assert_in_delta 0.3, @flat.harmonic_mean, 1E-8
    assert_in_delta 0, @flat.variance, 1E-8
    assert_in_delta 0, @flat.standard_deviation, 1E-8
    assert_in_delta 0, @flat.sample_standard_deviation, 1E-8
    assert_in_delta 30, @flat.sum, 1E-8
    assert_in_delta 0.3, @flat.min, 1E-8
    assert_in_delta 0.3, @flat.max, 1E-8
    assert_in_delta 0.3, @flat.percentile(25), 1E-8
    assert_in_delta 0.3, @flat.median, 1E-8
    assert_in_delta 0.3, @flat.percentile(75), 1E-8
    assert_equal 100, @flat.histogram(10).to_a.first[1]
    assert @flat.linear_regression.residues.all? { |r| r.abs <= 1E-6 }
  end

  def test_half
    assert_equal 100, @half.size
    assert_in_delta 24.75, @half.mean, 1E-8
    assert_in_delta 0.0, @half.geometric_mean, 1E-8
    assert_equal 'NaN', @half.harmonic_mean.to_s
    assert_in_delta 208.31, @half.variance, 1E-2
    assert_in_delta 14.43, @half.standard_deviation, 1E-2
    assert_in_delta 14.50, @half.sample_standard_deviation, 1E-2
    assert_in_delta 2475, @half.sum, 1E-8
    assert_in_delta 0, @half.min, 1E-8
    assert_in_delta 99 / 2.0, @half.max, 1E-8
    assert_in_delta 12.125, @half.percentile(25), 1E-8
    assert_in_delta 24.75, @half.median, 1E-8
    assert_in_delta 37.375, @half.percentile(75), 1E-8
    assert_equal [10] * 10, counts = @half.histogram(10).to_a.transpose[1]
    assert_equal 100, counts.inject { |s, x| s + x }
    assert @half.linear_regression.residues.all? { |r| r.abs <= 0.5 }
  end

  def test_rand
    assert_equal 100, @rand.size
    assert_in_delta 50.84, @rand.mean, 1E-2
    assert_in_delta 0.0, @rand.geometric_mean, 1E-8
    assert_equal 'NaN', @rand.harmonic_mean.to_s
    assert_in_delta 976.95, @rand.variance, 1E-2
    assert_in_delta 31.25, @rand.standard_deviation, 1E-2
    assert_in_delta 31.41, @rand.sample_standard_deviation, 1E-2
    assert_in_delta 5084, @rand.sum, 1E-8
    assert_in_delta 0, @rand.min, 1E-8
    assert_in_delta 98, @rand.max, 1E-8
    assert_in_delta 20.25, @rand.percentile(25), 1E-8
    assert_in_delta 50.0, @rand.median, 1E-8
    assert_in_delta 81, @rand.percentile(75), 1E-8
    assert_in_delta 0.05660, @rand.linear_regression.a, 1E-4
    assert_in_delta 47.9812, @rand.linear_regression.b, 1E-4
    assert @rand.linear_regression.slope_zero?
    assert_in_delta(-0.4019, @rand_down.linear_regression.a, 1E-4)
    assert_in_delta 82.7303, @rand_down.linear_regression.b, 1E-4
    assert !@rand_down.linear_regression.slope_zero?
    assert_in_delta 0.5151, @rand_up.linear_regression.a, 1E-4
    assert_in_delta(13.2320, @rand_up.linear_regression.b, 1E-4)
    assert !@rand_up.linear_regression.slope_zero?
    assert_nil @rand.detect_outliers
    assert !@rand.detect_autocorrelation[:detected]
    assert_equal [11, 14, 7, 9, 8, 7, 5, 11, 13, 15],
      counts = @rand.histogram(10).to_a.transpose[1]
    assert_equal 100, counts.inject { |s, x| s + x }
  end

  def test_rasi
    assert_equal 100, @rasi.size
    assert_in_delta 3.48, @rasi.mean, 1E-2
    assert_in_delta 0.0, @rasi.geometric_mean, 1E-8
    assert_equal 'NaN', @rasi.harmonic_mean.to_s
    assert_in_delta 1604.67, @rasi.variance, 1E-2
    assert_in_delta 40.05, @rasi.standard_deviation, 1E-2
    assert_in_delta 40.26, @rasi.sample_standard_deviation, 1E-2
    assert_in_delta 348.007, @rasi.sum, 1E-3
    assert_in_delta 92.81, @rasi.max, 1E-2
    assert_in_delta(-20.75, @rasi.percentile(25), 1E-2)
    assert_in_delta 0.0, @rasi.median, 1E-2
    assert_in_delta 30.58, @rasi.percentile(75), 1E-2
    assert_in_delta(-0.41, @rasi.linear_regression.a, 1E-2)
    assert_in_delta(24.35, @rasi.linear_regression.b, 1E-2)
    assert !@rasi.linear_regression.slope_zero?
    assert_equal 13, @rasi.detect_outliers[:high]
    assert @rasi.detect_autocorrelation[:detected]
    assert_equal [4, 6, 11, 13, 22, 15, 12, 4, 7, 6],
      counts = @rasi.histogram(10).to_a.transpose[1]
    assert_equal 100, counts.inject { |s, x| s + x }
  end

  def test_book
    assert_equal 70, @book.size
    assert_in_delta 51.25, @book.mean, 1E-2
    assert_in_delta 49.70, @book.geometric_mean, 1E-2
    assert_in_delta 47.98, @book.harmonic_mean, 1E-2
    assert_in_delta 148.36, @book.variance, 1E-2
    assert_in_delta 12.18, @book.standard_deviation, 1E-2
    assert_in_delta 12.26, @book.sample_standard_deviation, 1E-2
    assert_in_delta 3588.0, @book.sum, 1E-2
    assert_in_delta 23, @book.min, 1E-2
    assert_in_delta 89, @book.max, 1E-2
    assert_in_delta(43.75, @book.percentile(25), 1E-2)
    assert_in_delta 51.5, @book.median, 1E-2
    assert_in_delta 58.25, @book.percentile(75), 1E-2
    assert_in_delta(-0.0952, @book.linear_regression.a, 1E-4)
    assert_in_delta(54.6372, @book.linear_regression.b, 1E-4)
    assert @book.linear_regression.slope_zero?
    assert_equal 7, @book.detect_outliers[:high]
    ought = [1.0, -0.39, 0.3, -0.17, 0.07, -0.10, 0.05, 0.04, -0.04, -0.01,
      0.01, 0.11, -0.07, 0.15, 0.04, -0.01
    ]
    @book.autocorrelation[0, ought.size].zip(ought) do |x, x_o|
      assert_in_delta x, x_o, 8E-2
    end
    assert @book.detect_autocorrelation(10)[:detected]
    assert_equal [3, 4, 9, 12, 18, 14, 4, 5, 0, 1],
      counts = @book.histogram(10).to_a.transpose[1]
    assert_equal 70, counts.inject { |s, x| s + x }
    assert @flat.linear_regression.residues.all? { |r| r.abs <= 1E-6 }
  end

  def test_cover
    assert @flat.cover?(@flat)
    assert @flat_fuzzy2.cover?(@flat_fuzzy2)
    assert @flat_fuzzy.cover?(@flat_fuzzy)
    assert @flat.cover?(@flat_fuzzy)
    assert_operator @flat.suggested_sample_size(@flat_fuzzy), '>', 1000
    assert @flat.cover?(@flat_fuzzy2)
    assert_operator @flat.suggested_sample_size(@flat_fuzzy2), '>', 9000
    assert @flat_fuzzy.cover?(@flat)
    assert_operator @flat_fuzzy.suggested_sample_size(@flat), '>', 1000
    assert @flat_fuzzy2.cover?(@flat)
    assert_operator @flat_fuzzy2.suggested_sample_size(@flat), '>', 9000
    assert !@flat.cover?(@flat_higher)
    assert !@flat_higher.cover?(@flat)
    assert !@flat_fuzzy.cover?(@flat_higher)
    assert !@flat_fuzzy2.cover?(@flat_higher)
    assert !@flat_higher.cover?(@flat_fuzzy)
    assert !@flat_higher.cover?(@flat_fuzzy2)
    assert @flat_fuzzy.cover?(@flat_fuzzy2)
    assert_operator @flat_fuzzy.suggested_sample_size(@flat_fuzzy2), '>', 4000
    assert @flat_fuzzy2.cover?(@flat_fuzzy)
    assert_operator @flat_fuzzy2.suggested_sample_size(@flat_fuzzy), '>', 4000
    assert @rasi.cover?(@rasi_mean)
    assert_operator @rasi.suggested_sample_size(@rasi_mean), '>', 10_000
    assert @rasi_mean.cover?(@rasi)
    assert_operator @rasi_mean.suggested_sample_size(@rasi), '>', 10_000
    assert @rasi.cover?(@flat)
    assert_operator @rasi.suggested_sample_size(@flat), '>', 500
    assert @flat.cover?(@rasi)
    assert_operator @flat.suggested_sample_size(@rasi), '>', 500
  end
end
