Name:           libxfce4ui
Version:        4.20.0
Release:        1%{?dist}
Summary:        Commonly used Xfce widgets among the Xfce applications

License:        LGPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/libxfce4ui/4.20/libxfce4ui-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfconf-devel >= 4.20.0
BuildRequires:  libSM-devel
BuildRequires:  libICE-devel
BuildRequires:  startup-notification-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool
BuildRequires:  libX11-devel

%description
Commonly used Xfce widgets among the Xfce applications.

%package        devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description    devel
Development files for %{name}.

%prep
%autosetup

%build
%configure --disable-static
%make_build

%install
%make_install
find %{buildroot} -name '*.la' -delete

%find_lang libxfce4ui

%files -f libxfce4ui.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_libdir}/libxfce4ui-2.so.*
%{_libdir}/libxfce4kbd-private-3.so.*
%{_bindir}/xfce4-about
%{_datadir}/icons/hicolor/*/status/*
%{_sysconfdir}/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml

%files devel
%{_includedir}/xfce4/libxfce4ui-2/
%{_includedir}/xfce4/libxfce4kbd-private-3/
%{_libdir}/libxfce4ui-2.so
%{_libdir}/libxfce4kbd-private-3.so
%{_libdir}/pkgconfig/libxfce4ui-2.pc
%{_libdir}/pkgconfig/libxfce4kbd-private-3.pc

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
