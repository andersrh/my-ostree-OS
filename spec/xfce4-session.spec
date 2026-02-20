Name:           xfce4-session
Version:        4.20.0
Release:        1%{?dist}
Summary:        Session manager for Xfce

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/xfce4-session/4.20/xfce4-session-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  libxfce4windowing-devel >= 4.20.0
BuildRequires:  libSM-devel
BuildRequires:  libICE-devel
BuildRequires:  libwnck3-devel
BuildRequires:  systemd-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool
BuildRequires:  desktop-file-utils

%description
The Xfce Session Manager is a tool to manage the startup of the
Xfce desktop environment and to restore the session upon next login.

%prep
%autosetup

%build
%configure --enable-systemd
%make_build

%install
%make_install

%find_lang xfce4-session

%files -f xfce4-session.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/xfce4-session
%{_bindir}/xfce4-session-logout
%{_libdir}/xfce4/session/
%{_sysconfdir}/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
%{_datadir}/applications/xfce-session-logout.desktop
%{_datadir}/icons/hicolor/*/apps/org.xfce.session.png
%{_datadir}/icons/hicolor/*/apps/org.xfce.session.svg
%{_datadir}/xsessions/xfce.desktop

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
