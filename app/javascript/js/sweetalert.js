import swal from "sweetalert";
import { format, eachDayOfInterval } from "date-fns";

// OneSignal.sendSelfNotification(
//   /* Title (defaults if unset) */
//   "OneSignal Web Push Notification",
//   /* Message (defaults if unset) */
//   "Action buttons increase the ways your users can interact with your notification.",
//    /* URL (defaults if unset) */
//   'http://localhost:5000',
//   /* Icon */
//   'https://onesignal.com/images/notification_logo.png',
//   {
//     /* Additional data hash */
//     notificationType: 'news-feature'
//   },
// [{ /* Buttons */
//   /* Choose any unique identifier for your button. The ID of the clicked button is passed to you so you can identify which button is clicked */
//   id: 'like-button',
//   /* The text the button should display. Supports emojis. */
//   text: 'Like',
//   /* A valid publicly reachable URL to an icon. Keep this small because it's downloaded on each notification display. */
//   icon: 'http://i.imgur.com/N8SN8ZS.png',
//   /* The URL to open when this action button is clicked. See the sections below for special URLs that prevent opening any window. */
//   url: 'https://example.com/?_osp=do_not_open'
// },
// {
//   id: 'read-more-button',
//   text: 'Read more',
//   icon: 'http://i.imgur.com/MIxJp1L.png',
//   url: 'https://example.com/?_osp=do_not_open'
// }]
// );

const set_csrftoken = function () {
  $.ajaxPrefilter(function (options, originalOptions, jqXHR) {
    if (!options.crossDomain) {
      const token = $('meta[name="csrf-token"]').attr("content");
      if (token) {
        return jqXHR.setRequestHeader("X-CSRF-Token", token);
      }
    }
  });
};

set_csrftoken();

var date = new Date();
var today = format(date, "yyyy年MM月dd日");

// dockerコンテナ内のprecompileで解決したため不要に
// メールで服薬通知ができるようになったため、不要だがなぜかOneSignalのエラーがでて、
// かつスマホだけjqueryが反応しなくなったため、入れておく
// プッシュ通知復活させて毎日21時にプッシュ通知にする
OneSignal.push(function () {
  OneSignal.getUserId().then(function (userId) {
    console.log("OneSignal User ID:", userId);
  });
});

if (gon.user) {
  if (today === gon.medicine || gon.medicine) {
    console.log(gon.medicine);
  }
  if (today !== gon.medicine) {
    if (gon.gonnatake && gon.gft <= gon.njt || !gon.gonnatake) {
    document.addEventListener("turbolinks:load", () => {
      // $.delete("../../medicines")が効かないため、root_pathでgon.noexistを削除
      $.get("../../");
      swal(`${today} 今日の服薬は？`, "", {
        icon: "warning",
        buttons: {
          yet: {
            text: "まだ！",
            value: "yet",
          },
          gotit: {
            text: "完了!",
            value: "gotit",
          },
        },
        closeOnClickOutside: false,
        closeOnEsc: false,
      }).then((value) => {
        switch (value) {
          case "yet":
            // swal('また今度！','',"info")
            // var dateFormat = require("dateformat");
            // var now = dateFormat(new Date(),'HH:MM');

            swal("何時に服薬しましょう？", "", {
              content: {
                element: "input",
                attributes: {
                  type: "time",
                  value: `${gon.now}`,
                  // min:  `${gon.now}`
                },
              },
              icon: "info",
              closeOnClickOutside: false,
              closeOnEsc: false,
            }).then((value) => {
              // var takedate = format(date, 'yyyy-MM-dd');
              // const taketime = `${takedate} ${value}`
              $.post("../../medicines", {
                gonna_take_medicine_at: `${value}`,
              })

                .done(() => {
                  swal(`${value}`, "からアラートがでます！", {
                    button: false,
                  });
                  setTimeout("location.reload()", 1000);
                })

                .catch((err) => {
                  if (err) {
                    // do{
                    swal(
                      "現在時刻より遅い時間を選択してください!",
                      "",
                      "error"
                    ).then(() => {
                      swal("何時に服薬しましょう？", "", {
                        content: {
                          element: "input",
                          attributes: {
                            type: "time",
                            value: `${gon.now}`,
                          },
                        },
                        icon: "info",
                        closeOnClickOutside: false,
                        closeOnEsc: false,
                      })
                        // })
                        .then((value) => {
                          // var takedate = format(date, 'yyyy-MM-dd');
                          // const taketime = `${takedate} ${value}`
                          $.post("../../medicines", {
                            gonna_take_medicine_at: `${value}`,
                          })

                            .done(() => {
                              swal(`${value}`, "からアラートがでます！", {
                                closeOnClickOutside: false,
                                closeOnEsc: false,
                              });
                              setTimeout("location.reload()", 1000);
                              // $('.swal-button').on('click', function() {
                              //   location.reload()
                              // });
                            })

                            .fail(() => {
                              swal("再度お知らせします!");
                            });
                        });
                    });
                    // break;
                    // }while(gon.noexist === null);
                  }
                });
            });

            break;

          case "gotit":
            $.get("../../medicines/new", {
              took_medicine_at: `${today}`,
            });
            swal("Good job!", "", "success");
            setTimeout("location.reload()", 1000);
            break;
        }
      });
    });
  }
  }
  console.log(gon.gonnatake);
}
