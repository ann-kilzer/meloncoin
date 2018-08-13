App = {
    web3Provider: null,
    contracts: {},
    
    init: function() {
	// Load melons.
	$.getJSON('../melons.json', function(data) {
	    var melonsRow = $('#melonsRow');
	    var melonTemplate = $('#melonTemplate');
	    
	    for (i = 0; i < data.length; i ++) {
		melonTemplate.find('.panel-title').text(data[i].name);
		melonTemplate.find('img').attr('src', data[i].picture);
		melonTemplate.find('.melon-variety').text(data[i].variety);
		melonTemplate.find('.melon-location').text(data[i].location);
		
		melonsRow.append(melonTemplate.html());
	    }
	});
	
	return App.initWeb3();
    },
    
    initWeb3: function() {
	// Is there an injected web3 instance?
	if (typeof web3 !== 'undefined') {
	    App.web3Provider = web3.currentProvider;
	} else {
	    // If no injected web3 instance is detected, fall back to Ganache-cli
	    App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
	}
	web3 = new Web3(App.web3Provider);
	
	return App.initContract();
    },
    
    initContract: function() {
	$.getJSON('MelonFarm.json', function(data) {
	    // Get the necessary contract artifact file and instantiate it with truffle-contract
	    var MelonFarmArtifact = data;
	    App.contracts.MelonFarm = TruffleContract(MelonFarmArtifact);
	    
	    // Set the provider for our contract
	    App.contracts.MelonFarm.setProvider(App.web3Provider);
	
	});
	return App.bindEvents();
    },
    
    bindEvents: function() {
	$(document).on('click', '.btn-plant', App.plantMelon);
    },
    
    plantMelon: function() {
	var farm;

	web3.eth.getAccounts(function(error, accounts) {
	    if (error) {
		console.log(error);
	    }
	    
	    var account = accounts[0];
	    var plantTime = Math.floor((new Date).getTime() / 1000); // seconds since the epoch

	    
	    App.contracts.MelonFarm.deployed().then(function(instance) {
		farm = instance;
		
		return farm.launchMeloncoin(10, plantTime, 90, 10, {from: account});
	    }).catch(function(err) {
		console.log(err.message);
	    });
	});
    }
    
};

$(function() {
    $(window).load(function() {
	App.init();
    });
});
