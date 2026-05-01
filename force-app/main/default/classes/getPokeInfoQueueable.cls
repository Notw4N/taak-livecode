public without sharing class getPokeInfoQueueable implements Queueable, Database.AllowsCallouts{
    public static final Integer MAX_CALLOUTS = 50;
    public string endpoint;
    public string nextEndpoint = null;

    public getPokeInfoQueueable(String endpoint){
        this.endpoint = endpoint;
    }

    public void execute(QueueableContext context){
        List<ChallengeUser__c> pokemons = new List<ChallengeUser__c>();
        Integer totalCallouts = 0;

        while(totalCallouts < MAX_CALLOUTS){

            if(nextEndpoint != null){
                endpoint = nextEndpoint;
            }

            String response = getPokeInfo.getPokemonApiInfo(endpoint);
            List<PokeInfoWrapper.Result> results = getPokeInfo.parsePokeInfo(response);
            for(PokeInfoWrapper.Result result : results){
                ChallengeUser__c pokemon = new ChallengeUser__c();
                pokemon.Name = result.name;
                pokemon.Url__c = result.url;
                pokemons.add(pokemon);
            }
            totalCallouts++;
            nextEndpoint = getPokeInfo.parseNextURL(response);
            if (String.isBlank(nextEndpoint)){ // API retorna next = null na última página
                break;
            } 
        }

        if(!pokemons.isEmpty()){
            try{
                Database.UpsertResult[] upsertResult = Database.upsert(pokemons, ChallengeUser__c.Url__c, false);
            } catch(Exception e){
                System.debug('Erro no UPSERT: ' + e.getMessage());
            }
        }

        if(nextEndpoint != null){
            System.enqueueJob(new getPokeInfoQueueable(nextEndpoint));
        }
    }
}