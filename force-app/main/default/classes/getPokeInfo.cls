public without sharing class getPokeInfo {
    //Classe de Serviço que agrupa os métodos auxiliares.

    public static String getPokemonApiInfo (String endpoint){
        Http h = new Http();

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');

        HttpResponse res = h.send(req);

        if (res.getStatusCode() != 200) {
            throw new CalloutException(
                'Erro ao buscar informações da API: ' + res.getStatusCode() + ' - ' + res.getStatus()
            );
        }

        return res.getBody();
    }

    //Ajustei o retorno do método para retornar a lista de resultados usando a classe wrapper que eu criei 
    public static List<PokeInfoWrapper.Result> parsePokeInfo(String jsonString) {
        PokeInfoWrapper w = (PokeInfoWrapper) JSON.deserialize(jsonString, PokeInfoWrapper.class);
        if (w.results != null) {
            return w.results;
        }
        return new List<PokeInfoWrapper.Result>();
    }

    public static String parseNextURL (String jsonString){
        Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        return (String)jsonMap.get('next');
    }
}