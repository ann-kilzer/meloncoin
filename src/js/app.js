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
		melonTemplate.find('.melon-grow-period').text(data[i].growing_period);
		melonTemplate.find('.melon-ripe-period').text(data[i].ripe_period);
		melonTemplate.find('.btn-plant').attr('data-id', i);
		
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
	//$(document).on('click', '.btn-plant', App.plantMelon());
	document.getElementById('btn-plant').setAttribute('onclick', `App.plantMelon(1,2)`);
    },
    
    plantMelon: function(melons, index) {
	var farm;

	web3.eth.getAccounts(function(error, accounts) {
	    if (error) {
		console.log(error);
	    }
	    
	    var account = accounts[0];
	    var plantTime = Math.floor((new Date).getTime() / 1000); // seconds since the epoch
	    var plantDays = document.getElementsByClassName("melon-grow-period")[index].innerText
	    var ripeDays = document.getElementsByClassName("melon-ripe-period")[index].innerText
	    
	    
	    App.contracts.MelonFarm.deployed().then(function(instance) {
		farm = instance;
		
		return farm.launchMeloncoin(melons, plantTime, plantDays, ripeDays, {from: account});
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
