var SelectedMoney = 0;
disabled = false;

const green = document.querySelector(".green")
const black = document.querySelector(".black")
LAST_ = "";
NEWS_ = "";
lastUI = "nothing";
dataUI = {}

$(function () {
    function displayUI(bool, id) {
        if (bool) {
            $(id).show();
        } else {
            $(id).hide();
        }
    }

    displayUI(false, "#container")
    displayUI(false, "#inventoryPage")
    displayUI(false, "#walletPage")
    displayUI(false, "#identityPage")
    displayUI(false, "#billingPage")
    displayUI(false, "#control");
    
    window.addEventListener('message', function(event) {
        var item = event.data;
        disabled = false;
        
        if (item.type === "container") {
            if (item.status == true ) {
                displayUI(true, "#container");
            } else {
                displayUI(false, "#container");
            }
        } else if (item.type === "inventoryPage") {
            if (item.status == true ) {
                displayUI(true, "#inventoryPage");
                displayUI(true, "#control");

                inventorySetup(item.data.Items);

                $('.item').draggable({
                    helper: 'clone',
                    appendTo: 'body',
                    zIndex: 99999,
                    revert: 'invalid',
                    start: function (event, ui) {
                        if (disabled) {
                            return false;
                        }
        
                        $(this).css('background-image', 'none');
                        itemData = $(this).data("item");
        
                        if (!itemData.canRemove) {
                            $("#dropped").addClass("disabled");
                            $("#gived").addClass("disabled");
                        }
        
                        if (!itemData.usable) {
                            $("#used").addClass("disabled");
                            $("#utils").addClass("disabled");
                        }
                    },
                    stop: function () {
                        itemData = $(this).data("item");
        
                        if (itemData !== undefined && itemData.name !== undefined) {
                            $(this).css('background-image', 'url(\'img/items/' + itemData.name + '.png\'');
                            $("#dropped").removeClass("disabled");
                            $("#utils").removeClass("disabled");
                            $("#used").removeClass("disabled");
                            $("#gived").removeClass("disabled");
                        }
                    }
                });
            } else {
                    displayUI(false, "#inventoryPage");
            }
        } else if (item.type === "billingPage") {
            if (item.status == true ) {
                displayUI(true, "#billingPage");
                billingSetup(item.data);
            } else {
                    displayUI(false, "#billingPage");
            }
        } else if (item.type === "walletPage") {
            if (item.status == true ) {
                displayUI(true, "#walletPage");
                if (item.data.Money) {
                    var money = item.data.Money;
                    document.getElementById("money").textContent = ("$" + money);
                }
                if (item.data.blackMoney) {
                    var blackMoney = item.data.blackMoney;
                    document.getElementById("blackMoney").textContent = ("$" + blackMoney);
                }
            } else {
                    displayUI(false, "#walletPage")
            }
        } else if (item.type === "identityPage") {
            if (item.status == true ) {
                displayUI(true, "#identityPage");
                if (item.data.firstname) {
                    var firstname = item.data.firstname;
                    document.getElementById("firstname").textContent = (firstname);
                } 
                if (item.data.lastname) {
                    var lastname = item.data.lastname;
                    document.getElementById("lastname").textContent = (lastname);
                } 
                if (item.data.dateofbirth) {
                    var dateofbirth = item.data.dateofbirth;
                    document.getElementById("dateofbirth").textContent = (dateofbirth);
                }
                if (item.data.job) {
                    var job = item.data.job;
                    document.getElementById("job").textContent = (job);
                } 
                if (item.data.job2) {
                    var job2 = item.data.job2;
                    document.getElementById("job2").textContent = (job2);
                }
            } else {
                    displayUI(false, "#identityPage");
            }
        } else if (item.type === "refreshMoney") {
            if (item.data.Money) {
                var money = item.data.Money
                document.getElementById("money").textContent = ("$" + money)
            }
            if (item.data.blackMoney) {
                var blackMoney = item.data.blackMoney
                document.getElementById("blackMoney").textContent = ("$" + blackMoney)
            }
        }
    })
    document.onkeyup = function(data) {
        if (data.which == 27) {
            $.post("https://mSquareMenu/exit", JSON.stringify({}));
        }
    }
    
    $("#closed").click(function() {
        $.post("https://mSquareMenu/exit", JSON.stringify({}));
    })

    $("#inventory").click(function() {
        $.post("https://mSquareMenu/inventory", JSON.stringify({}));
    })

    $("#wallet").click(function() {
        $.post("https://mSquareMenu/wallet", JSON.stringify({}));
    })

    $("#billing").click(function() {
        $.post("https://mSquareMenu/billing", JSON.stringify({}));
    })

    $("#identity").click(function() {
        $.post("https://mSquareMenu/identity", JSON.stringify({}));
    })

    $("#give").click(function() {
        let inputValue = $("#count").val();
        if (!SelectedMoney) {
            $.post("https://mSquareMenu/errornoclose", JSON.stringify({
                error: "Erreur : vous n'avez pas sélectionné de type de money"
            }));
        } else if (!inputValue) {
            $.post("https://mSquareMenu/errornoclose", JSON.stringify({
                error: "Erreur : vous n'avez pas entré de montant"
            }));
        } else if (inputValue <= 0) {
            inputValue = 0;
        } 
        $.post("https://mSquareMenu/give", JSON.stringify({
            type: SelectedMoney,
            amount: inputValue
        }));
    })

    $("#drop").click(function() {
        let inputValue = $("#count").val();
        if (!SelectedMoney) {
            $.post("https://mSquareMenu/errornoclose", JSON.stringify({
                error: "Erreur : vous n'avez pas sélectionné de type de money"
            }));
        } else if (!inputValue) {
            $.post("https://mSquareMenu/errornoclose", JSON.stringify({
                error: "Erreur : vous n'avez pas entré de montant"
            }));
        } else if (inputValue <= 0) {
            inputValue = 0;
        } 
        $.post("https://mSquareMenu/drop", JSON.stringify({
            type: SelectedMoney,
            amount: inputValue,
            item: SelectedItem
        }));
    })
    $('#drop-id-card').click(function() {
        $.post("https://mSquareMenu/ShowID", JSON.stringify({}));
    });
    $('#drop-dmv-card').click(function() {
        $.post("https://mSquareMenu/ShowDMV", JSON.stringify({}));
    });
})

$(document).ready(function() {
    $('#used').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            if (itemData.usable) {
                $.post("https://mSquareMenu/UseItem", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#countItem").val())
                }));
            }
        }
    });

    $('#utils').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            if (itemData.usable) {
                $.post("https://mSquareMenu/RacItem", JSON.stringify({
                    item: itemData
                }));
            }
        }
    });

    $('#give_player').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            if (itemData.canRemove) {
                $.post("https://mSquareMenu/GiveItem", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#countItem").val())
                }));
            }
        }
    });

    $('#drop_player').droppable({
        hoverClass: 'hoverControl',
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            if (itemData.canRemove) {
                $.post("https://mSquareMenu/DropItem", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#countItem").val())
                }));
            }
        }
    });

    $('#playerInventory').droppable({
        drop: function (event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");
        }
    });
});

function isNumberKey(evt){
    var charCode = (evt.which) ? evt.which : evt.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}

green.addEventListener('click', function () {
    SelectedMoney = "money"
    SelectedItem = "item_money"
    green.style.backgroundColor = '#0a0a0ab6'
    black.style.backgroundColor = '#181818b6'
});

black.addEventListener('click', function () {
    SelectedMoney = "black_money"
    SelectedItem = "item_account"
    black.style.backgroundColor = '#0a0a0ab6'
    green.style.backgroundColor = '#181818b6'
});

function setCount(item) {
    count = item.count

    if (item.limit > 0) {
        count = item.count
    }

    if (item.type === "item_weapon") {
        if (count == 0) {
            count = "";
        } else {
            count = '<img src="assets/img/bullet.png" class="ammoIcon"> ' + item.count;
        }
    }

    if (item.type === "item_account" || item.type === "item_money") {
        count = formatMoney(item.count);
    }

    return count;
}

function inventorySetup(items) {
    $("#playerInventory").html("");
    $.each(items, function (index, item) {
        count = setCount(item);
        item.count = count;

        $("#playerInventory").append('<div class="slot"><div id="item-' + index + '" class="item"> <img src="assets/img/items/'+ item.name +'.png" class="item-icon">' + '<div class="item-count">' + count + '<div class="item-name">' + item.label + '</div>' + '</div></div ></div>');
        $('#item-' + index).data('item', item);
    });
    document.getElementById("blackMoney").textContent = ("$" + blackMoney)
}

function billingSetup(bills) {
    $("#playerBills").html("");
    $.each(bills, function (index, bill) {
        $("#playerBills").append('<div class="listbills"><div class="namebills"><h3>' + bill.label + '</h3></div><div class="pricebills"><h3>' + bill.amount + '$</h3></div><div id="bill-' + index + '" class="buttonbills"><h3>Payer</h3></div></div>');
        $('#bill-' + index).click(function () {
            $.post("https://mSquareMenu/PayBill", JSON.stringify({
                bill: bill
            }));
        })
    });
}