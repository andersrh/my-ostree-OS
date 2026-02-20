Name:           xfce4-notifyd
Version:        0.9.7
Release:        1%{?dist}
Summary:        Simple notification daemon for Xfce

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/apps/xfce4-notifyd/0.9/xfce4-notifyd-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  libnotify-devel
BuildRequires:  libcanberra-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool
BuildRequires:  desktop-file-utils

%description
Xfce4-notifyd is a simple notification daemon for Xfce that implements
the freedesktop.org desktop notifications specification.

%prep
%autosetup

%build
%configure
%make_build

%install
%make_install

%find_lang xfce4-notifyd

%files -f xfce4-notifyd.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/xfce4-notifyd-config
%{_libdir}/xfce4/notifyd/xfce4-notifyd
%{_datadir}/applications/xfce4-notifyd-config.desktop
%{_datadir}/icons/hicolor/*/apps/org.xfce.notification.png
%{_datadir}/icons/hicolor/*/apps/org.xfce.notification.svg
%{_datadir}/dbus-1/services/org.xfce.Notifications.service
%{_datadir}/dbus-1/services/org.xfce.xfce4-notifyd.Notifications.service

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 0.9.7-1
- Initial release for Xfce 4.20 compatibility
埋め込み
