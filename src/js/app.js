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
	$(document).on('click', '.btn-plant', App.plantMelon);
    },
    
    plantMelon: function(event) {
	event.preventDefault();

	var index = parseInt($(event.target).data('id'));
	var melons = 3 // todo read from form
	var melonDiv = document.getElementsByClassName('panel-body')[index]
	
	var farm;

	alert(index)
	
	web3.eth.getAccounts(function(error, accounts) {
	    if (error) {
		console.log(error);
	    }
	    
	    var account = accounts[0];
	    var plantTime = Math.floor((new Date).getTime() / 1000); // seconds since the epoch
	    var plantDays = melonDiv.getElementsByClassName("melon-grow-period")[0].innerText
	    var ripeDays = melonDiv.getElementsByClassName("melon-ripe-period")[0].innerText
	    
	    
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
