import '../entity/k_entity.dart';

class KLineEntity extends KEntity {
  int time;
  double open;
  double high;
  double low;
  double close;
  double vol;
  double quoteVolume;

  KLineEntity.fromCustom(
      {this.time,
      this.open,
      this.close,
      this.high,
      this.low,
      this.vol,
      this.quoteVolume});

  KLineEntity.fromJson(List<dynamic> json) {
    time = (json[0] as num)?.toInt();
    open = (json[1] as num)?.toDouble();
    high = (json[2] as num)?.toDouble();
    low = (json[3] as num)?.toDouble();
    close = (json[4] as num)?.toDouble();
    vol = (json[5] as num)?.toDouble();
    quoteVolume = (json[6] as num)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['open'] = this.open;
    data['close'] = this.close;
    data['high'] = this.high;
    data['low'] = this.low;
    data['vol'] = this.vol;
    data['quoteVolume'] = this.quoteVolume;

    return data;
  }

  @override
  String toString() {
    return 'MarketModel{open: $open, high: $high, low: $low, close: $close, vol: $vol, time: $time,}';
  }
}
