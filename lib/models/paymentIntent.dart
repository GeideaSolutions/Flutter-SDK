class PaymentIntent
{
    
    String? id, type;
    
    PaymentIntent({this.id, this.type});
    
    PaymentIntent.fromMap(Map<String, dynamic> map) {
        id = map['id'];
        type = map['type'];
    }

    @override
    String toString() {
        return 'PaymentIntent{id: $id, type: $type}';
    }

}